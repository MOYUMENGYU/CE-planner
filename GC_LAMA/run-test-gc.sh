#!/usr/bin/env bash
# GC_LAMA / GC 批量自动测试脚本（修正版）
#
# 已按 GC_LAMA 项目 README 与 plan 脚本重新审查：
#   ./plan <domain_path> <problem_path> <result_path> <true/false>
#
# 默认执行：
#   ./plan <domain.pddl> <problem.pddl> <case_result_dir>/gc_result false
#
# 关键修复：
# - 支持 examples/d.pddl + examples/p.pddl 这种空后缀 d/p 配对，避免 Bash 空数组下标报错。
# - 支持 d10_10_dispose/p10_10_dispose、d_safe_100/p_safe_100、d_cube/p_cube 等 d/p 配对。
# - 支持 blocks_domain.pddl + blocks_b2_correct.pddl 这种下划线 domain 模式。
# - 支持 lng-4-2-3-domain.pddl + lng-4-2-3-p.pddl 这种连字符 domain/p 模式。
# - 支持 raoskeys_d04.pddl + raoskeys_p04.pddl 这种 prefix_d / prefix_p 模式。
# - 保存完整控制台输出 console.log，并保存 finalplan、C_Plan、trans_file、belief、output.sas、output、result_prefix.* 等中间文件。
# - 支持 timeout、内存限制、benchmark/problem 过滤、dry-run、Ctrl+C 优雅退出。

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR"
TEST_ROOT=""
LOG_ROOT_BASE=""
RESULT_ROOT_BASE=""
GC_PLAN=""
DISPLAY_MODE="false"
TIMEOUT_SEC=3600
MEM_LIMIT_GB=16
MEM_LIMIT_KB=$((MEM_LIMIT_GB * 1024 * 1024))
BENCHMARK_FILTER=""
PROBLEM_FILTER=""
RUN_ID="$(date +%Y%m%d_%H%M%S)"
CONTINUE_ON_ERROR=1
DRY_RUN=0
CLEANUP_ROOT=1

usage() {
    cat <<USAGE
用法：
  $(basename "$0") [选项]

选项：
  --root DIR               GC_LAMA 项目根目录，默认：脚本所在目录
  -t, --test-root DIR      测试根目录，默认：<root>/examples
  -l, --log-root DIR       日志根目录，默认：<root>/gc_test_logs
  -r, --result-root DIR    结果根目录，默认：<root>/gc_result_output_batch
  --plan FILE              GC plan 脚本路径，默认：<root>/plan
  --display true|false     传给 ./plan 的第4个参数，默认 false
  -b, --benchmark NAME     只运行指定 benchmark 目录名/路径组件，例如 examples / blocks / dispose
  -p, --problem NAME       只运行指定 problem，例如 p10_10_dispose / p10_10_dispose.pddl / blocks_b2_correct
  --run-id ID              指定本轮运行 ID
  --timeout SEC            单用例超时秒数，默认 3600
  --mem-gb GB              单用例内存限制 GB，默认 16
  --dry-run                只列出将运行的测例，不实际执行
  --stop-on-error          遇到失败立即停止
  --no-cleanup-root        不清理根目录中 trans_file/finalplan/C_Plan/output.sas/output 等中间文件
  -h, --help               显示帮助

示例：
  ./run-test-gc.sh -t ./examples -p p10_10_dispose
  ./run-test-gc.sh -t ./examples -p blocks_b2_correct
  ./run-test-gc.sh -t ./examples --dry-run
  ./run-test-gc.sh -t ./GC-Benchmark-succes --timeout 3600 --mem-gb 16
USAGE
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --root) ROOT_DIR="$2"; shift 2 ;;
        -t|--test-root) TEST_ROOT="$2"; shift 2 ;;
        -l|--log-root) LOG_ROOT_BASE="$2"; shift 2 ;;
        -r|--result-root) RESULT_ROOT_BASE="$2"; shift 2 ;;
        --plan) GC_PLAN="$2"; shift 2 ;;
        --display) DISPLAY_MODE="$2"; shift 2 ;;
        -b|--benchmark) BENCHMARK_FILTER="$2"; shift 2 ;;
        -p|--problem) PROBLEM_FILTER="$2"; shift 2 ;;
        --run-id) RUN_ID="$2"; shift 2 ;;
        --timeout) TIMEOUT_SEC="$2"; shift 2 ;;
        --mem-gb) MEM_LIMIT_GB="$2"; shift 2 ;;
        --dry-run) DRY_RUN=1; shift ;;
        --stop-on-error) CONTINUE_ON_ERROR=0; shift ;;
        --no-cleanup-root) CLEANUP_ROOT=0; shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "[错误] 未知参数：$1" >&2; usage; exit 1 ;;
    esac
done

abs_path_existing_dir() {
    local d="$1"
    cd "$d" 2>/dev/null && pwd
}

abs_path_existing_file() {
    local f="$1" d b
    d="$(dirname "$f")"
    b="$(basename "$f")"
    d="$(cd "$d" 2>/dev/null && pwd)" || return 1
    printf '%s/%s\n' "$d" "$b"
}

ROOT_DIR="$(abs_path_existing_dir "$ROOT_DIR")"
if [[ -z "$ROOT_DIR" ]]; then
    echo "[错误] 无法解析项目根目录。" >&2
    exit 1
fi

[[ -z "$GC_PLAN" ]] && GC_PLAN="$ROOT_DIR/plan"
if [[ -f "$GC_PLAN" ]]; then
    GC_PLAN="$(abs_path_existing_file "$GC_PLAN")"
fi

[[ -z "$TEST_ROOT" ]] && TEST_ROOT="$ROOT_DIR/examples"
[[ -z "$LOG_ROOT_BASE" ]] && LOG_ROOT_BASE="$ROOT_DIR/gc_test_logs"
[[ -z "$RESULT_ROOT_BASE" ]] && RESULT_ROOT_BASE="$ROOT_DIR/gc_result_output_batch"

if [[ ! -x "$GC_PLAN" ]]; then
    echo "[错误] 未找到可执行的 GC plan 脚本：$GC_PLAN" >&2
    echo "[提示] 请确认 plan 存在并 chmod +x，或用 --plan 指定路径。" >&2
    exit 1
fi

if [[ ! -d "$TEST_ROOT" ]]; then
    echo "[错误] 未找到测试目录：$TEST_ROOT" >&2
    exit 1
fi
TEST_ROOT="$(abs_path_existing_dir "$TEST_ROOT")"

case "$DISPLAY_MODE" in
    true|false|TRUE|FALSE|True|False) ;;
    *) echo "[错误] --display 只能是 true 或 false。" >&2; exit 1 ;;
esac

if [[ ! "$TIMEOUT_SEC" =~ ^[0-9]+$ ]] || [[ "$TIMEOUT_SEC" -le 0 ]]; then
    echo "[错误] --timeout 必须是正整数秒数。" >&2
    exit 1
fi
if [[ ! "$MEM_LIMIT_GB" =~ ^[0-9]+$ ]] || [[ "$MEM_LIMIT_GB" -le 0 ]]; then
    echo "[错误] --mem-gb 必须是正整数 GB。" >&2
    exit 1
fi
MEM_LIMIT_KB=$((MEM_LIMIT_GB * 1024 * 1024))

mkdir -p "$LOG_ROOT_BASE" "$RESULT_ROOT_BASE"
LOG_ROOT_BASE="$(abs_path_existing_dir "$LOG_ROOT_BASE")"
RESULT_ROOT_BASE="$(abs_path_existing_dir "$RESULT_ROOT_BASE")"

LOG_ROOT="$LOG_ROOT_BASE/$RUN_ID"
RESULT_ROOT="$RESULT_ROOT_BASE/$RUN_ID"
SUMMARY_LOG="$LOG_ROOT/summary.log"
FAILED_CASES_FILE="$LOG_ROOT/failed_cases.txt"
ANOMALIES_LOG="$LOG_ROOT/anomalies.log"

mkdir -p "$LOG_ROOT" "$RESULT_ROOT"
: > "$SUMMARY_LOG"
: > "$FAILED_CASES_FILE"
: > "$ANOMALIES_LOG"

resolve_timeout_cmd() {
    if command -v timeout >/dev/null 2>&1; then echo timeout; return 0; fi
    if command -v gtimeout >/dev/null 2>&1; then echo gtimeout; return 0; fi
    return 1
}
TIMEOUT_CMD="$(resolve_timeout_cmd || true)"
if [[ -z "$TIMEOUT_CMD" ]]; then
    echo "[错误] 当前机器没有可用的 timeout/gtimeout 命令。" >&2
    exit 1
fi

if command -v pgrep >/dev/null 2>&1; then HAVE_PGREP=1; else HAVE_PGREP=0; fi

log_summary() { printf '%s\n' "$*" >> "$SUMMARY_LOG"; }
log_anomaly() { printf '%s\n' "$*" >> "$ANOMALIES_LOG"; printf '%s\n' "$*" >> "$SUMMARY_LOG"; }

strip_case_ext() {
    local x
    x="$(basename "$1")"
    x="${x%.pddl~}"
    x="${x%.pddl}"
    echo "$x"
}

matches_problem_filter() {
    local filter="$1" case_name="$2" file_base="$3" pair_suffix="$4"
    if [[ -z "$filter" ]]; then return 0; fi
    local f_noext="$filter"
    f_noext="${f_noext%.pddl~}"
    f_noext="${f_noext%.pddl}"

    if [[ "$file_base" == "$filter" || "$case_name" == "$filter" || "$case_name" == "$f_noext" ]]; then
        return 0
    fi
    if [[ -n "$pair_suffix" && ( "$pair_suffix" == "$filter" || "$pair_suffix" == "$f_noext" ) ]]; then
        return 0
    fi

    local case_without_p="${case_name#p}"
    local case_without_pu="${case_name#p_}"
    if [[ "$case_without_p" == "$f_noext" || "$case_without_pu" == "$f_noext" ]]; then
        return 0
    fi
    return 1
}

matches_benchmark_filter() {
    local bench_dir="$1"
    if [[ -z "$BENCHMARK_FILTER" ]]; then return 0; fi
    local rel="${bench_dir#$TEST_ROOT/}" part
    if [[ "$rel" == "$bench_dir" || -z "$rel" ]]; then rel="$(basename "$bench_dir")"; fi
    IFS='/' read -r -a parts <<< "$rel"
    for part in "${parts[@]}"; do
        if [[ "$part" == "$BENCHMARK_FILTER" ]]; then return 0; fi
    done
    if [[ "$(basename "$bench_dir")" == "$BENCHMARK_FILTER" ]]; then return 0; fi
    return 1
}

case_id_for() {
    local bench_dir="$1" case_name="$2" rel
    rel="${bench_dir#$TEST_ROOT/}"
    if [[ "$rel" == "$bench_dir" || -z "$rel" ]]; then rel="$(basename "$bench_dir")"; fi
    printf '%s/%s\n' "$rel" "$case_name" | sed 's#[^A-Za-z0-9_./-]#_#g'
}

append_case() {
    local bench_dir="$1" domain_file="$2" problem_file="$3" case_name="$4" pair_suffix="$5"
    local problem_base key
    problem_base="$(basename "$problem_file")"
    matches_benchmark_filter "$bench_dir" || return 0
    matches_problem_filter "$PROBLEM_FILTER" "$case_name" "$problem_base" "$pair_suffix" || return 0

    domain_file="$(abs_path_existing_file "$domain_file")" || return 0
    problem_file="$(abs_path_existing_file "$problem_file")" || return 0
    key="$domain_file|$problem_file"
    if [[ -n "${SEEN_CASES[$key]:-}" ]]; then return 0; fi
    SEEN_CASES[$key]=1
    CASE_BENCH_DIRS+=("$bench_dir")
    CASE_DOMAINS+=("$domain_file")
    CASE_PROBLEMS+=("$problem_file")
    CASE_NAMES+=("$case_name")
    CASE_SUFFIXES+=("$pair_suffix")
}

find_nearest_domain() {
    local dir="$1" next
    while [[ "$dir" == "$TEST_ROOT"* ]]; do
        if [[ -f "$dir/domain.pddl" ]]; then printf '%s\n' "$dir/domain.pddl"; return 0; fi
        if [[ -f "$dir/domain_one.pddl" ]]; then printf '%s\n' "$dir/domain_one.pddl"; return 0; fi
        next="$(dirname "$dir")"
        [[ "$next" == "$dir" ]] && break
        dir="$next"
    done
    return 1
}

is_problem_candidate() {
    local base="$1"
    case "$base" in
        domain.pddl|domain_one.pddl) return 1 ;;
        domain_*.pddl|d*.pddl|*_domain.pddl|*-domain.pddl) return 1 ;;
        output.sas|output|belief|trans_file|finalplan|C_Plan|sas_plan*) return 1 ;;
        *.1) return 1 ;;
    esac
    return 0
}

add_dp_pair_maps_case() {
    local bench_dir="$1" domain_file="$2" problem_file="$3" raw_suffix="$4"
    local problem_base case_name pair_suffix
    problem_base="$(basename "$problem_file")"
    case_name="$(strip_case_ext "$problem_base")"
    pair_suffix="$raw_suffix"
    append_case "$bench_dir" "$domain_file" "$problem_file" "$case_name" "$pair_suffix"
}

discover_cases() {
    declare -gA SEEN_CASES=()
    declare -ga CASE_BENCH_DIRS=()
    declare -ga CASE_DOMAINS=()
    declare -ga CASE_PROBLEMS=()
    declare -ga CASE_NAMES=()
    declare -ga CASE_SUFFIXES=()

    local bench_dir domain_file problem_file problem_base case_name
    while IFS= read -r -d '' bench_dir; do
        # 1) 共享 domain.pddl/domain_one.pddl。
        domain_file=""
        if [[ -f "$bench_dir/domain.pddl" ]]; then domain_file="$bench_dir/domain.pddl";
        elif [[ -f "$bench_dir/domain_one.pddl" ]]; then domain_file="$bench_dir/domain_one.pddl"; fi
        if [[ -n "$domain_file" ]]; then
            while IFS= read -r -d '' problem_file; do
                problem_base="$(basename "$problem_file")"
                is_problem_candidate "$problem_base" || continue
                case_name="$(strip_case_ext "$problem_base")"
                append_case "$bench_dir" "$domain_file" "$problem_file" "$case_name" ""
            done < <(find "$bench_dir" -maxdepth 1 -type f \( -name '*.pddl' -o -name '*.pddl~' \) -print0 | sort -z -V)
            if [[ -d "$bench_dir/instances" ]]; then
                while IFS= read -r -d '' problem_file; do
                    problem_base="$(basename "$problem_file")"
                    is_problem_candidate "$problem_base" || continue
                    case_name="$(strip_case_ext "$problem_base")"
                    append_case "$bench_dir" "$domain_file" "$problem_file" "$case_name" ""
                done < <(find "$bench_dir/instances" -maxdepth 1 -type f \( -name '*.pddl' -o -name '*.pddl~' \) -print0 | sort -z -V)
            fi
        fi

        # 2) 当前目录是 instances：使用最近父目录 domain。
        local dir_base
        dir_base="$(basename "$bench_dir")"
        if [[ "$dir_base" == "instances" || "$dir_base" == "unsat_instances" || "$dir_base" == "unsat_instance" ]]; then
            domain_file="$(find_nearest_domain "$(dirname "$bench_dir")" || true)"
            if [[ -n "$domain_file" ]]; then
                while IFS= read -r -d '' problem_file; do
                    problem_base="$(basename "$problem_file")"
                    is_problem_candidate "$problem_base" || continue
                    case_name="$(strip_case_ext "$problem_base")"
                    append_case "$bench_dir" "$domain_file" "$problem_file" "$case_name" ""
                done < <(find "$bench_dir" -maxdepth 1 -type f \( -name '*.pddl' -o -name '*.pddl~' \) -print0 | sort -z -V)
            fi
        fi

        # 3) 标准 d*.pddl + p*.pddl 成对。支持 d.pddl/p.pddl 空后缀。
        declare -A d_map=()
        declare -A p_map=()
        local d_file p_file d_base p_base d_key p_key map_key raw_key
        while IFS= read -r -d '' d_file; do
            d_base="$(basename "$d_file")"
            d_key="${d_base%.pddl~}"; d_key="${d_key%.pddl}"; d_key="${d_key#d}"
            map_key="${d_key:-__EMPTY__}"
            d_map["$map_key"]="$d_file"
        done < <(find "$bench_dir" -maxdepth 1 -type f \( -name 'd*.pddl' -o -name 'd*.pddl~' \) -print0 | sort -z -V)
        while IFS= read -r -d '' p_file; do
            p_base="$(basename "$p_file")"
            p_key="${p_base%.pddl~}"; p_key="${p_key%.pddl}"; p_key="${p_key#p}"
            map_key="${p_key:-__EMPTY__}"
            p_map["$map_key"]="$p_file"
        done < <(find "$bench_dir" -maxdepth 1 -type f \( -name 'p*.pddl' -o -name 'p*.pddl~' \) -print0 | sort -z -V)
        while IFS= read -r map_key; do
            [[ -z "$map_key" ]] && continue
            if [[ -n "${p_map[$map_key]:-}" ]]; then
                raw_key="$map_key"; [[ "$raw_key" == "__EMPTY__" ]] && raw_key=""
                add_dp_pair_maps_case "$bench_dir" "${d_map[$map_key]}" "${p_map[$map_key]}" "$raw_key"
            fi
        done < <(printf '%s\n' "${!d_map[@]}" | sort -V)

        # 4) *_domain.pddl + prefix_*.pddl，例如 blocks_domain.pddl + blocks_b2_correct.pddl。
        local dom_file dom_base prefix prob_file prob_base
        while IFS= read -r -d '' dom_file; do
            dom_base="$(basename "$dom_file")"
            prefix="${dom_base%_domain.pddl}"
            while IFS= read -r -d '' prob_file; do
                prob_base="$(basename "$prob_file")"
                is_problem_candidate "$prob_base" || continue
                case_name="$(strip_case_ext "$prob_base")"
                append_case "$bench_dir" "$dom_file" "$prob_file" "$case_name" "$case_name"
            done < <(find "$bench_dir" -maxdepth 1 -type f \( -name "${prefix}_*.pddl" -o -name "${prefix}_*.pddl~" \) ! -name "${prefix}_domain.pddl" -print0 | sort -z -V)
        done < <(find "$bench_dir" -maxdepth 1 -type f -name '*_domain.pddl' -print0 | sort -z -V)

        # 5) *-domain.pddl + *-p.pddl，例如 lng-4-2-3-domain.pddl + lng-4-2-3-p.pddl。
        while IFS= read -r -d '' dom_file; do
            dom_base="$(basename "$dom_file")"
            prefix="${dom_base%-domain.pddl}"
            while IFS= read -r -d '' prob_file; do
                prob_base="$(basename "$prob_file")"
                is_problem_candidate "$prob_base" || continue
                case_name="$(strip_case_ext "$prob_base")"
                append_case "$bench_dir" "$dom_file" "$prob_file" "$case_name" "$case_name"
            done < <(find "$bench_dir" -maxdepth 1 -type f \( -name "${prefix}-p.pddl" -o -name "${prefix}-*.pddl" \) ! -name "${prefix}-domain.pddl" -print0 | sort -z -V)
        done < <(find "$bench_dir" -maxdepth 1 -type f -name '*-domain.pddl' -print0 | sort -z -V)

        # 6) prefix_dXX.pddl + prefix_pXX.pddl，例如 raoskeys_d04.pddl + raoskeys_p04.pddl。
        declare -A pd_map=()
        declare -A pp_map=()
        local name prefix_key suffix_key compound_key
        while IFS= read -r -d '' d_file; do
            d_base="$(basename "$d_file")"
            name="${d_base%.pddl~}"; name="${name%.pddl}"
            if [[ "$name" =~ ^(.+)_d(.+)$ ]]; then
                compound_key="${BASH_REMATCH[1]}|${BASH_REMATCH[2]}"
                pd_map["$compound_key"]="$d_file"
            fi
        done < <(find "$bench_dir" -maxdepth 1 -type f \( -name '*_d*.pddl' -o -name '*_d*.pddl~' \) -print0 | sort -z -V)
        while IFS= read -r -d '' p_file; do
            p_base="$(basename "$p_file")"
            name="${p_base%.pddl~}"; name="${name%.pddl}"
            if [[ "$name" =~ ^(.+)_p(.+)$ ]]; then
                compound_key="${BASH_REMATCH[1]}|${BASH_REMATCH[2]}"
                pp_map["$compound_key"]="$p_file"
            fi
        done < <(find "$bench_dir" -maxdepth 1 -type f \( -name '*_p*.pddl' -o -name '*_p*.pddl~' \) -print0 | sort -z -V)
        while IFS= read -r compound_key; do
            [[ -z "$compound_key" ]] && continue
            if [[ -n "${pp_map[$compound_key]:-}" ]]; then
                prob_base="$(basename "${pp_map[$compound_key]}")"
                case_name="$(strip_case_ext "$prob_base")"
                append_case "$bench_dir" "${pd_map[$compound_key]}" "${pp_map[$compound_key]}" "$case_name" "${compound_key#*|}"
            fi
        done < <(printf '%s\n' "${!pd_map[@]}" | sort -V)

        # 7) domain_<suffix>.pddl + instance_<suffix>.pddl 成对。
        declare -A gd_map=()
        declare -A gi_map=()
        local g_file g_base g_key
        while IFS= read -r -d '' g_file; do
            g_base="$(basename "$g_file")"
            g_key="${g_base%.pddl}"; g_key="${g_key#domain_}"
            gd_map["$g_key"]="$g_file"
        done < <(find "$bench_dir" -maxdepth 1 -type f -name 'domain_*.pddl' -print0 | sort -z -V)
        while IFS= read -r -d '' g_file; do
            g_base="$(basename "$g_file")"
            g_key="${g_base%.pddl}"; g_key="${g_key#instance_}"
            gi_map["$g_key"]="$g_file"
        done < <(find "$bench_dir" -maxdepth 1 -type f -name 'instance_*.pddl' -print0 | sort -z -V)
        while IFS= read -r g_key; do
            [[ -z "$g_key" ]] && continue
            if [[ -n "${gi_map[$g_key]:-}" ]]; then
                append_case "$bench_dir" "${gd_map[$g_key]}" "${gi_map[$g_key]}" "instance_$g_key" "$g_key"
            fi
        done < <(printf '%s\n' "${!gd_map[@]}" | sort -V)

    done < <(find "$TEST_ROOT" -type d -print0 | sort -z -V)
}

cleanup_root_transients() {
    [[ $CLEANUP_ROOT -eq 1 ]] || return 0
    rm -f "$ROOT_DIR/trans_file" \
          "$ROOT_DIR/belief" \
          "$ROOT_DIR/output.sas" \
          "$ROOT_DIR/output" \
          "$ROOT_DIR/finalplan" \
          "$ROOT_DIR/C_Plan" \
          "$ROOT_DIR"/sas_plan* \
          "$ROOT_DIR"/result_output* \
          "$ROOT_DIR"/gc_result* 2>/dev/null || true
}

save_case_artifacts() {
    local case_result_dir="$1" result_prefix="$2" f
    for f in "$result_prefix" "$result_prefix".*; do
        if [[ -f "$f" ]]; then cp -f "$f" "$case_result_dir/$(basename "$f")" 2>/dev/null || true; fi
    done
    for f in "$ROOT_DIR/trans_file" "$ROOT_DIR/belief" "$ROOT_DIR/output.sas" "$ROOT_DIR/output" "$ROOT_DIR/finalplan" "$ROOT_DIR/C_Plan" "$ROOT_DIR"/sas_plan*; do
        if [[ -f "$f" ]]; then cp -f "$f" "$case_result_dir/$(basename "$f")" 2>/dev/null || true; fi
    done
    find "$case_result_dir" -maxdepth 1 -type f | sort -V > "$case_result_dir/artifacts.txt" 2>/dev/null || true
}

resolve_command_args() {
    local domain_file="$1" problem_file="$2" result_prefix="$3"
    CMD=("$GC_PLAN" "$domain_file" "$problem_file" "$result_prefix" "$DISPLAY_MODE")
}

classify_result() {
    local rc="$1" log_file="$2" case_result_dir="$3"
    if [[ "$rc" -eq 124 || "$rc" -eq 137 ]]; then echo "TIMEOUT"; return 0; fi
    if grep -Eiq "Traceback|SyntaxError|TabError|IndentationError|python.*not found|python2.*not found|No such file or directory|Permission denied|cannot execute" "$log_file"; then
        echo "SCRIPT_OR_PYTHON_ERROR"; return 0
    fi
    if grep -Eiq "parse error|syntax error|Expected|Undeclared|Domain file .*does not exist|Problem file .*does not exist" "$log_file"; then
        echo "TRANSLATE_OR_PDDL_ERROR"; return 0
    fi
    if grep -Eiq "Segmentation fault|core dumped|bad alloc" "$log_file"; then
        echo "PREPROCESS_OR_SEARCH_ERROR"; return 0
    fi
    if [[ -s "$case_result_dir/finalplan" || -s "$case_result_dir/C_Plan" || -s "$case_result_dir/gc_result.1" ]]; then
        echo "FOUND_PLAN"; return 0
    fi
    if grep -Eiq "Solution found|Plan found|final plan|C_Plan|problem solved" "$log_file"; then echo "FOUND_PLAN"; return 0; fi
    if grep -Eiq "unsolvable|no solution|no plan|failed" "$log_file"; then echo "NO_SOLUTION_OR_FAILED"; return 0; fi
    if [[ "$rc" -eq 0 ]]; then echo "EXIT0_NEED_CHECK"; else echo "EXIT_CODE_${rc}"; fi
}

SUCCESS_CASES=0
FAILED_CASES=0
TOTAL_CASES=0
DISCOVERED_CASES=0
DISCOVERED_BENCHMARKS=0
STOP_REQUESTED=0
STOP_REQUESTED_EXIT_CODE=0
INTERRUPT_COUNT=0
CURRENT_CHILD_PID=""
CURRENT_CASE_LOG_FILE=""
CURRENT_CASE_ID=""
START_TS=$(date +%s)
FINALIZED=0
IMMEDIATE_INTERRUPT_RECORDED=0

kill_process_tree() {
    local pid="$1" sig="$2" child
    [[ -z "$pid" ]] && return 0
    [[ "$pid" -le 0 ]] 2>/dev/null && return 0
    if [[ $HAVE_PGREP -eq 1 ]]; then
        while IFS= read -r child; do
            [[ -z "$child" ]] && continue
            kill_process_tree "$child" "$sig"
        done < <(pgrep -P "$pid" 2>/dev/null || true)
    fi
    kill -"$sig" "$pid" 2>/dev/null || true
}

terminate_current_child_now() {
    if [[ -n "$CURRENT_CHILD_PID" ]]; then
        kill_process_tree "$CURRENT_CHILD_PID" TERM
        sleep 1
        kill_process_tree "$CURRENT_CHILD_PID" KILL
    fi
}

finalize_summary() {
    if [[ $FINALIZED -eq 1 ]]; then return 0; fi
    FINALIZED=1
    local elapsed
    elapsed=$(($(date +%s) - START_TS))
    [[ $STOP_REQUESTED -eq 1 ]] && log_summary "[中止] 已收到中断/停止请求。"
    log_summary "[汇总] 可运行benchmark数=$DISCOVERED_BENCHMARKS"
    log_summary "[汇总] 可运行用例总数=$DISCOVERED_CASES"
    log_summary "[汇总] 实际运行用例数=$TOTAL_CASES"
    log_summary "[汇总] 成功=$SUCCESS_CASES"
    log_summary "[汇总] 失败=$FAILED_CASES"
    log_summary "[汇总] 总耗时=${elapsed}s"
    log_summary "[汇总] 日志目录=$LOG_ROOT"
    log_summary "[汇总] 结果目录=$RESULT_ROOT"
    log_summary "[汇总] 失败清单=$FAILED_CASES_FILE"
    log_summary "[汇总] 异常清单=$ANOMALIES_LOG"
}

handle_interrupt() {
    INTERRUPT_COUNT=$((INTERRUPT_COUNT + 1))
    if [[ $INTERRUPT_COUNT -eq 1 ]]; then
        STOP_REQUESTED=1
        STOP_REQUESTED_EXIT_CODE=130
        echo
        echo "[中断] 已收到中断信号。当前 case=${CURRENT_CASE_ID:-N/A}。当前用例结束后退出；再次 Ctrl+C 立即终止。"
        log_summary "[中断] 收到 SIGINT/SIGTERM，当前 case=${CURRENT_CASE_ID:-N/A}。"
    else
        echo
        echo "[中断] 第二次收到中断信号，立即终止当前用例并退出。"
        if [[ -n "$CURRENT_CASE_LOG_FILE" ]]; then echo "[用户中断] 第二次 Ctrl+C，立即终止。" >> "$CURRENT_CASE_LOG_FILE"; fi
        if [[ -n "$CURRENT_CASE_ID" && $IMMEDIATE_INTERRUPT_RECORDED -eq 0 ]]; then
            FAILED_CASES=$((FAILED_CASES + 1))
            echo "$CURRENT_CASE_ID INTERRUPTED_FORCE log=$CURRENT_CASE_LOG_FILE" >> "$FAILED_CASES_FILE"
            IMMEDIATE_INTERRUPT_RECORDED=1
        fi
        terminate_current_child_now
        finalize_summary
        exit 130
    fi
}
trap 'handle_interrupt' INT TERM

is_success_status() { [[ "$1" == "FOUND_PLAN" ]]; }

run_one_case() {
    local idx="$1" bench_dir="$2" domain_file="$3" problem_file="$4" case_name="$5"
    local case_id case_log_dir case_result_dir case_log_file result_prefix start_ts end_ts elapsed rc status cmd_string
    case_id="$(case_id_for "$bench_dir" "$case_name")"
    case_log_dir="$LOG_ROOT/$(dirname "$case_id")"
    case_result_dir="$RESULT_ROOT/$case_id"
    case_log_file="$case_log_dir/$(basename "$case_id").log"
    result_prefix="$case_result_dir/gc_result"
    mkdir -p "$case_log_dir" "$case_result_dir"

    cp -f "$domain_file" "$case_result_dir/domain.pddl" 2>/dev/null || true
    cp -f "$problem_file" "$case_result_dir/problem.pddl" 2>/dev/null || true

    resolve_command_args "$domain_file" "$problem_file" "$result_prefix"
    printf '%q ' "${CMD[@]}" > "$case_result_dir/command.txt"
    printf '\n' >> "$case_result_dir/command.txt"
    cmd_string="$(cat "$case_result_dir/command.txt")"

    if [[ $DRY_RUN -eq 1 ]]; then
        echo "[DRY-RUN] $idx/$DISCOVERED_CASES case=$case_id"
        echo "  domain=$domain_file"
        echo "  problem=$problem_file"
        echo "  result_prefix=$result_prefix"
        echo "  command=cd $ROOT_DIR && $cmd_string"
        return 0
    fi

    TOTAL_CASES=$((TOTAL_CASES + 1))
    CURRENT_CASE_ID="$case_id"
    CURRENT_CASE_LOG_FILE="$case_log_file"

    cleanup_root_transients
    start_ts=$(date +%s)
    {
        echo "[开始时间] $(date '+%F %T')"
        echo "[求解器] GC_LAMA / GC"
        echo "[ROOT_DIR] $ROOT_DIR"
        echo "[GC_PLAN] $GC_PLAN"
        echo "[TEST_ROOT] $TEST_ROOT"
        echo "[display] $DISPLAY_MODE"
        echo "[benchmark_dir] $bench_dir"
        echo "[case_name] $case_name"
        echo "[domain] $domain_file"
        echo "[problem] $problem_file"
        echo "[result_prefix] $result_prefix"
        echo "[result_dir] $case_result_dir"
        echo "[timeout_sec] $TIMEOUT_SEC"
        echo "[mem_limit_gb] $MEM_LIMIT_GB"
        echo "[mem_limit_kb_ulimit_v] $MEM_LIMIT_KB"
        echo "[command] cd $ROOT_DIR && $cmd_string"
        echo
    } > "$case_log_file"

    (
        trap '' INT TERM
        cd "$ROOT_DIR" || exit 1
        ulimit -v "$MEM_LIMIT_KB" 2>/dev/null || true
        exec "$TIMEOUT_CMD" --signal=TERM --kill-after=10s "$TIMEOUT_SEC" "${CMD[@]}"
    ) >> "$case_log_file" 2>&1 &
    CURRENT_CHILD_PID=$!

    wait "$CURRENT_CHILD_PID"
    rc=$?
    CURRENT_CHILD_PID=""
    end_ts=$(date +%s)
    elapsed=$((end_ts - start_ts))

    save_case_artifacts "$case_result_dir" "$result_prefix"
    status="$(classify_result "$rc" "$case_log_file" "$case_result_dir")"
    {
        echo
        echo "[结束时间] $(date '+%F %T')"
        echo "[耗时秒] $elapsed"
        echo "[退出码] $rc"
        echo "[状态] $status"
    } >> "$case_log_file"

    cp -f "$case_log_file" "$case_result_dir/console.log"
    cleanup_root_transients

    if is_success_status "$status"; then
        SUCCESS_CASES=$((SUCCESS_CASES + 1))
        log_summary "  [完成] $case_id status=$status exit_code=$rc elapsed=${elapsed}s log=$case_log_file"
    else
        FAILED_CASES=$((FAILED_CASES + 1))
        echo "$case_id  $status  exit_code=$rc log=$case_log_file" >> "$FAILED_CASES_FILE"
        log_summary "  [失败] $case_id status=$status exit_code=$rc elapsed=${elapsed}s log=$case_log_file"
        if [[ $CONTINUE_ON_ERROR -eq 0 ]]; then
            STOP_REQUESTED=1
            STOP_REQUESTED_EXIT_CODE=1
        fi
    fi

    echo "[进度] solver=GC case=$case_id status=$status elapsed=${elapsed}s success=$SUCCESS_CASES failed=$FAILED_CASES total=$TOTAL_CASES/$DISCOVERED_CASES"
    CURRENT_CASE_ID=""
    CURRENT_CASE_LOG_FILE=""
}

log_summary "[开始] ROOT_DIR=$ROOT_DIR"
log_summary "[开始] TEST_ROOT=$TEST_ROOT"
log_summary "[开始] GC_PLAN=$GC_PLAN"
log_summary "[开始] DISPLAY_MODE=$DISPLAY_MODE"
log_summary "[开始] LOG_ROOT=$LOG_ROOT"
log_summary "[开始] RESULT_ROOT=$RESULT_ROOT"
log_summary "[开始] TIMEOUT_SEC=$TIMEOUT_SEC"
log_summary "[开始] MEM_LIMIT_GB=$MEM_LIMIT_GB"
[[ -n "$BENCHMARK_FILTER" ]] && log_summary "[过滤] benchmark=$BENCHMARK_FILTER"
[[ -n "$PROBLEM_FILTER" ]] && log_summary "[过滤] problem=$PROBLEM_FILTER"
log_summary ""

discover_cases
DISCOVERED_CASES=${#CASE_DOMAINS[@]}
declare -A BENCH_SET=()
for bd in "${CASE_BENCH_DIRS[@]}"; do BENCH_SET["$bd"]=1; done
DISCOVERED_BENCHMARKS=${#BENCH_SET[@]}

log_summary "[预扫描] 可运行benchmark数=$DISCOVERED_BENCHMARKS"
log_summary "[预扫描] 可运行用例总数=$DISCOVERED_CASES"
log_summary ""

echo "[开始] solver=GC run_id=$RUN_ID timeout=${TIMEOUT_SEC}s mem=${MEM_LIMIT_GB}GB"
echo "[开始] root=$ROOT_DIR"
echo "[开始] test_root=$TEST_ROOT"
echo "[开始] plan=$GC_PLAN"
echo "[开始] display=$DISPLAY_MODE"
echo "[开始] benchmark_count=$DISCOVERED_BENCHMARKS case_count=$DISCOVERED_CASES"

if [[ "$DISCOVERED_CASES" -eq 0 ]]; then
    echo "[错误] 没有发现可运行测例。请检查 -t、-b、-p 或 benchmark 结构。" >&2
    log_anomaly "[错误] 没有发现可运行测例。"
    finalize_summary
    exit 1
fi

for i in "${!CASE_DOMAINS[@]}"; do
    n=$((i + 1))
    run_one_case "$n" "${CASE_BENCH_DIRS[$i]}" "${CASE_DOMAINS[$i]}" "${CASE_PROBLEMS[$i]}" "${CASE_NAMES[$i]}"
    if [[ $STOP_REQUESTED -eq 1 ]]; then break; fi
done

finalize_summary
ELAPSED=$(($(date +%s) - START_TS))
echo "[完成] total=$TOTAL_CASES success=$SUCCESS_CASES failed=$FAILED_CASES elapsed=${ELAPSED}s"
echo "[完成] summary=$SUMMARY_LOG"
echo "[完成] result_root=$RESULT_ROOT"

if [[ $STOP_REQUESTED -eq 1 ]]; then exit "$STOP_REQUESTED_EXIT_CODE"; fi
if [[ $FAILED_CASES -gt 0 ]]; then exit 1; fi
exit 0

