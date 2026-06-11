#!/usr/bin/env bash
# ICPCES 批量自动测试脚本
# 参考 gCPCES 自动测试脚本结构改写。
#
# 默认执行你已确认可运行的命令形式：
#   python3 conformant_planning.py -d <domain.pddl> -i <problem.pddl> -p superfd
#
# 说明：
# - 默认以脚本所在目录为 ICPCES 项目根目录。
# - 默认测试根目录：<root>/FD-Benchmarks。
# - 默认 planner：superfd，即 ICPCES / incremental Fast Downward 路径。
# - 默认不传 -s，严格复现你已确认可运行的命令；如需指定搜索引擎，用 --search-engine。
# - 每个测例会复制 domain/problem 到独立结果目录再运行，避免污染原 benchmark。
# - 每个测例保存完整 console.log、命令、输入文件、生成的 *_sample / *_plan / domain_conformant 等中间文件。
# - 支持 timeout、内存限制、benchmark/problem 过滤、dry-run、Ctrl+C 优雅退出。
# - 默认自动补齐项目缺失的 options.py / instantiate.py 桥接文件；可用 --no-ensure-bridges 关闭。
#
# 常用命令：
#   ./run-test-icpces.sh -t ./FD-Benchmarks -b blockworld -p p01
#   ./run-test-icpces.sh -t ./FD-Benchmarks -b dispose -p p_4_1
#   ./run-test-icpces.sh -t ./FD-Benchmarks --timeout 3600 --mem-gb 16
#   ./run-test-icpces.sh -t ./FD-Benchmarks --dry-run
#   ./run-test-icpces.sh --planner ff -t ./FD-Benchmarks -b blockworld -p p01

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR"
TEST_ROOT=""
LOG_ROOT_BASE=""
RESULT_ROOT_BASE=""
PYTHON_BIN="${PYTHON_BIN:-python3}"

PLANNER="superfd"
SEARCH_ENGINE=""       # 默认不传 -s，复现当前已确认可运行命令。
EXTRA_ARGS=()
ENSURE_BRIDGES=1
BUILD_FD=0
USE_COPIED_INPUTS=1

TIMEOUT_SEC=3600
MEM_LIMIT_GB=16
MEM_LIMIT_KB=$((MEM_LIMIT_GB * 1024 * 1024))
BENCHMARK_FILTER=""
PROBLEM_FILTER=""
RUN_ID="$(date +%Y%m%d_%H%M%S)"
CONTINUE_ON_ERROR=1
DRY_RUN=0

usage() {
    cat <<USAGE
用法：
  $(basename "$0") [选项]

选项：
  --root DIR               ICPCES 项目根目录，默认：脚本所在目录
  -t, --test-root DIR      测试根目录，默认：<root>/FD-Benchmarks
  -l, --log-root DIR       日志根目录，默认：<root>/icpces_test_logs
  -r, --result-root DIR    结果根目录，默认：<root>/icpces_result_output_batch
  --python FILE            Python 解释器，默认：python3
  --planner NAME           传给 conformant_planning.py 的 -p，默认：superfd
  --search-engine STRING   传给 conformant_planning.py 的 -s；默认不传，复现已确认可运行命令
  --extra "ARGS"           额外原样追加给 conformant_planning.py 的参数
  --build-fd               运行前执行：cd downward && python3 build.py
  --ensure-bridges         自动创建 options.py / instantiate.py，默认开启
  --no-ensure-bridges      不自动创建 options.py / instantiate.py
  --use-original-inputs    不复制输入文件，直接用原 benchmark 路径运行
  -b, --benchmark NAME     只运行指定 benchmark 目录名，例如 blockworld / dispose / look-grab_4_1_1
  -p, --problem NAME       只运行指定 problem，例如 p01 / p01.pddl / p_4_1 / 4_1
  --run-id ID              指定本轮运行 ID
  --timeout SEC            单用例超时秒数，默认：3600
  --mem-gb GB              单用例内存限制 GB，默认：16
  --dry-run                只列出将运行的测例，不实际执行
  --stop-on-error          遇到失败立即停止
  -h, --help               显示帮助

输出：
  控制台日志：<log_root>/<run_id>/<benchmark>/<case>.log
  控制台备份：<result_root>/<run_id>/<benchmark>/<case>/console.log
  命令记录：  <result_root>/<run_id>/<benchmark>/<case>/command.txt
  输入备份：  <result_root>/<run_id>/<benchmark>/<case>/domain.pddl / problem.pddl
  汇总日志：  <log_root>/<run_id>/summary.log
  失败清单：  <log_root>/<run_id>/failed_cases.txt
  异常清单：  <log_root>/<run_id>/anomalies.log

示例：
  ./run-test-icpces.sh -t ./FD-Benchmarks -b blockworld -p p01
  ./run-test-icpces.sh -t ./FD-Benchmarks -b dispose -p p_4_1
  ./run-test-icpces.sh -t ./FD-Benchmarks --timeout 3600 --mem-gb 16
  ./run-test-icpces.sh -t ./FD-Benchmarks --dry-run
  ./run-test-icpces.sh --planner ff -t ./FD-Benchmarks -b blockworld -p p01
  ./run-test-icpces.sh --search-engine 'eager(single(ff()))' -t ./FD-Benchmarks -b blockworld -p p01
USAGE
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --root)
            ROOT_DIR="$2"; shift 2 ;;
        -t|--test-root)
            TEST_ROOT="$2"; shift 2 ;;
        -l|--log-root)
            LOG_ROOT_BASE="$2"; shift 2 ;;
        -r|--result-root)
            RESULT_ROOT_BASE="$2"; shift 2 ;;
        --python)
            PYTHON_BIN="$2"; shift 2 ;;
        --planner)
            PLANNER="$2"; shift 2 ;;
        --search-engine)
            SEARCH_ENGINE="$2"; shift 2 ;;
        --extra)
            # shellcheck disable=SC2206
            EXTRA_ARGS=($2); shift 2 ;;
        --build-fd)
            BUILD_FD=1; shift ;;
        --ensure-bridges)
            ENSURE_BRIDGES=1; shift ;;
        --no-ensure-bridges)
            ENSURE_BRIDGES=0; shift ;;
        --use-original-inputs)
            USE_COPIED_INPUTS=0; shift ;;
        -b|--benchmark)
            BENCHMARK_FILTER="$2"; shift 2 ;;
        -p|--problem)
            PROBLEM_FILTER="$2"; shift 2 ;;
        --run-id)
            RUN_ID="$2"; shift 2 ;;
        --timeout)
            TIMEOUT_SEC="$2"; shift 2 ;;
        --mem-gb)
            MEM_LIMIT_GB="$2"; shift 2 ;;
        --dry-run)
            DRY_RUN=1; shift ;;
        --stop-on-error)
            CONTINUE_ON_ERROR=0; shift ;;
        -h|--help)
            usage; exit 0 ;;
        *)
            echo "[错误] 未知参数：$1" >&2
            usage
            exit 1 ;;
    esac
done

abs_path_existing_dir() {
    local d="$1"
    cd "$d" 2>/dev/null && pwd
}

abs_path_existing_file() {
    local f="$1"
    local d b
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

[[ -z "$TEST_ROOT" ]] && TEST_ROOT="$ROOT_DIR/FD-Benchmarks"
[[ -z "$LOG_ROOT_BASE" ]] && LOG_ROOT_BASE="$ROOT_DIR/icpces_test_logs"
[[ -z "$RESULT_ROOT_BASE" ]] && RESULT_ROOT_BASE="$ROOT_DIR/icpces_result_output_batch"

if [[ ! -f "$ROOT_DIR/conformant_planning.py" ]]; then
    echo "[错误] 未找到 conformant_planning.py：$ROOT_DIR/conformant_planning.py" >&2
    exit 1
fi

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1 && [[ ! -x "$PYTHON_BIN" ]]; then
    echo "[错误] 找不到 Python 解释器：$PYTHON_BIN" >&2
    exit 1
fi

if [[ ! -d "$TEST_ROOT" ]]; then
    echo "[错误] 未找到测试目录：$TEST_ROOT" >&2
    exit 1
fi
TEST_ROOT="$(abs_path_existing_dir "$TEST_ROOT")"

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
    if command -v timeout >/dev/null 2>&1; then
        echo "timeout"; return 0
    fi
    if command -v gtimeout >/dev/null 2>&1; then
        echo "gtimeout"; return 0
    fi
    return 1
}

TIMEOUT_CMD="$(resolve_timeout_cmd || true)"
if [[ -z "$TIMEOUT_CMD" ]]; then
    echo "[错误] 当前机器没有可用的 timeout/gtimeout 命令。" >&2
    exit 1
fi

if command -v pgrep >/dev/null 2>&1; then
    HAVE_PGREP=1
else
    HAVE_PGREP=0
fi

log_summary() { printf '%s\n' "$*" >> "$SUMMARY_LOG"; }
log_anomaly() { printf '%s\n' "$*" >> "$ANOMALIES_LOG"; printf '%s\n' "$*" >> "$SUMMARY_LOG"; }

ensure_bridge_files() {
    if [[ $ENSURE_BRIDGES -ne 1 ]]; then
        return 0
    fi
    if [[ ! -f "$ROOT_DIR/options.py" ]]; then
        cat > "$ROOT_DIR/options.py" <<'PY'
from translate.option import *
PY
        log_summary "[修补] 已创建 options.py -> translate.option"
    fi
    if [[ ! -f "$ROOT_DIR/instantiate.py" ]]; then
        cat > "$ROOT_DIR/instantiate.py" <<'PY'
from translate.instantiate import *
PY
        log_summary "[修补] 已创建 instantiate.py -> translate.instantiate"
    fi
}

build_fast_downward() {
    if [[ $BUILD_FD -ne 1 ]]; then
        return 0
    fi
    if [[ ! -f "$ROOT_DIR/downward/build.py" ]]; then
        echo "[错误] 未找到 downward/build.py，无法编译 Fast Downward。" >&2
        exit 1
    fi
    echo "[构建] 开始编译 Fast Downward：$ROOT_DIR/downward"
    log_summary "[构建] cd $ROOT_DIR/downward && $PYTHON_BIN build.py"
    (
        cd "$ROOT_DIR/downward" || exit 1
        "$PYTHON_BIN" build.py
    ) | tee "$LOG_ROOT/build_fd.log"
}

strip_case_ext() {
    local x
    x="$(basename "$1")"
    x="${x%.pddl~}"
    x="${x%.pddl}"
    echo "$x"
}

matches_problem_filter() {
    local filter="$1"
    local case_name="$2"
    local file_base="$3"
    local pair_suffix="$4"

    if [[ -z "$filter" ]]; then
        return 0
    fi

    local f_noext="$filter"
    f_noext="${f_noext%.pddl~}"
    f_noext="${f_noext%.pddl}"

    if [[ "$file_base" == "$filter" || "$case_name" == "$filter" || "$case_name" == "$f_noext" ]]; then
        return 0
    fi
    if [[ -n "$pair_suffix" && ( "$pair_suffix" == "$filter" || "$pair_suffix" == "$f_noext" ) ]]; then
        return 0
    fi
    # 允许 p_4_1 用 4_1 过滤，p20-1 用 20-1 过滤。
    local case_without_p="${case_name#p}"
    local case_without_pu="${case_name#p_}"
    if [[ "$case_without_p" == "$f_noext" || "$case_without_pu" == "$f_noext" ]]; then
        return 0
    fi
    return 1
}

matches_benchmark_filter() {
    local bench_dir="$1"
    if [[ -z "$BENCHMARK_FILTER" ]]; then
        return 0
    fi
    local rel="${bench_dir#$TEST_ROOT/}"
    local part
    IFS='/' read -r -a parts <<< "$rel"
    for part in "${parts[@]}"; do
        if [[ "$part" == "$BENCHMARK_FILTER" ]]; then
            return 0
        fi
    done
    return 1
}

case_id_for() {
    local bench_dir="$1"
    local case_name="$2"
    local rel
    rel="${bench_dir#$TEST_ROOT/}"
    if [[ "$rel" == "$bench_dir" ]]; then
        rel="$(basename "$bench_dir")"
    fi
    printf '%s/%s\n' "$rel" "$case_name" | sed 's#[^A-Za-z0-9_./-]#_#g'
}

append_case() {
    local bench_dir="$1"
    local domain_file="$2"
    local problem_file="$3"
    local case_name="$4"
    local pair_suffix="$5"
    local problem_base key

    problem_base="$(basename "$problem_file")"

    matches_benchmark_filter "$bench_dir" || return 0
    matches_problem_filter "$PROBLEM_FILTER" "$case_name" "$problem_base" "$pair_suffix" || return 0

    domain_file="$(abs_path_existing_file "$domain_file")" || return 0
    problem_file="$(abs_path_existing_file "$problem_file")" || return 0
    key="$domain_file|$problem_file"

    if [[ -n "${SEEN_CASES[$key]:-}" ]]; then
        return 0
    fi
    SEEN_CASES[$key]=1
    CASE_BENCH_DIRS+=("$bench_dir")
    CASE_DOMAINS+=("$domain_file")
    CASE_PROBLEMS+=("$problem_file")
    CASE_NAMES+=("$case_name")
    CASE_SUFFIXES+=("$pair_suffix")
}

find_nearest_domain() {
    local dir="$1"
    while [[ "$dir" == "$TEST_ROOT"* ]]; do
        if [[ -f "$dir/domain.pddl" ]]; then
            printf '%s\n' "$dir/domain.pddl"; return 0
        fi
        if [[ -f "$dir/domain_one.pddl" ]]; then
            printf '%s\n' "$dir/domain_one.pddl"; return 0
        fi
        local next
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
        domain_*.pddl|d*.pddl) return 1 ;;
        *_sample|*_sample_plan|*domain_conformant|output.sas|sas_plan*) return 1 ;;
    esac
    return 0
}

discover_cases() {
    declare -gA SEEN_CASES=()
    declare -ga CASE_BENCH_DIRS=()
    declare -ga CASE_DOMAINS=()
    declare -ga CASE_PROBLEMS=()
    declare -ga CASE_NAMES=()
    declare -ga CASE_SUFFIXES=()

    local bench_dir domain_file problem_file problem_base case_name
    local d_file p_file d_base p_base d_key p_key key

    while IFS= read -r -d '' bench_dir; do
        # 1) 同目录共享 domain.pddl / domain_one.pddl。
        domain_file=""
        if [[ -f "$bench_dir/domain.pddl" ]]; then
            domain_file="$bench_dir/domain.pddl"
        elif [[ -f "$bench_dir/domain_one.pddl" ]]; then
            domain_file="$bench_dir/domain_one.pddl"
        fi
        if [[ -n "$domain_file" ]]; then
            # 同目录 problem。
            while IFS= read -r -d '' problem_file; do
                problem_base="$(basename "$problem_file")"
                is_problem_candidate "$problem_base" || continue
                case_name="$(strip_case_ext "$problem_base")"
                append_case "$bench_dir" "$domain_file" "$problem_file" "$case_name" ""
            done < <(find "$bench_dir" -maxdepth 1 -type f \( -name '*.pddl' -o -name '*.pddl~' \) -print0 | sort -z -V)
            # instances 子目录。
            if [[ -d "$bench_dir/instances" ]]; then
                while IFS= read -r -d '' problem_file; do
                    problem_base="$(basename "$problem_file")"
                    is_problem_candidate "$problem_base" || continue
                    case_name="$(strip_case_ext "$problem_base")"
                    append_case "$bench_dir" "$domain_file" "$problem_file" "$case_name" ""
                done < <(find "$bench_dir/instances" -maxdepth 1 -type f \( -name '*.pddl' -o -name '*.pddl~' \) -print0 | sort -z -V)
            fi
        fi

        # 2) 当前目录本身是 instances/unsat_instances：使用最近父目录 domain。
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

        # 3) d*.pddl + p*.pddl 成对。
        declare -A d_map=()
        declare -A p_map=()
        while IFS= read -r -d '' d_file; do
            d_base="$(basename "$d_file")"
            d_key="${d_base%.pddl~}"
            d_key="${d_key%.pddl}"
            d_key="${d_key#d}"
            d_map["$d_key"]="$d_file"
        done < <(find "$bench_dir" -maxdepth 1 -type f \( -name 'd*.pddl' -o -name 'd*.pddl~' \) -print0 | sort -z -V)
        while IFS= read -r -d '' p_file; do
            p_base="$(basename "$p_file")"
            p_key="${p_base%.pddl~}"
            p_key="${p_key%.pddl}"
            p_key="${p_key#p}"
            p_map["$p_key"]="$p_file"
        done < <(find "$bench_dir" -maxdepth 1 -type f \( -name 'p*.pddl' -o -name 'p*.pddl~' \) -print0 | sort -z -V)
        while IFS= read -r key; do
            [[ -z "$key" ]] && continue
            if [[ -n "${p_map[$key]:-}" ]]; then
                append_case "$bench_dir" "${d_map[$key]}" "${p_map[$key]}" "p$key" "$key"
            fi
        done < <(printf '%s\n' "${!d_map[@]}" | sort -V)

        # 4) domain_<suffix>.pddl + instance_<suffix>.pddl 成对。
        declare -A gd_map=()
        declare -A gi_map=()
        local g_file g_base g_key
        while IFS= read -r -d '' g_file; do
            g_base="$(basename "$g_file")"
            g_key="${g_base%.pddl}"
            g_key="${g_key#domain_}"
            gd_map["$g_key"]="$g_file"
        done < <(find "$bench_dir" -maxdepth 1 -type f -name 'domain_*.pddl' -print0 | sort -z -V)
        while IFS= read -r -d '' g_file; do
            g_base="$(basename "$g_file")"
            g_key="${g_base%.pddl}"
            g_key="${g_key#instance_}"
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

prepare_case_inputs() {
    local domain_file="$1"
    local problem_file="$2"
    local case_result_dir="$3"
    RUN_DOMAIN="$domain_file"
    RUN_PROBLEM="$problem_file"
    if [[ $USE_COPIED_INPUTS -eq 1 ]]; then
        RUN_DOMAIN="$case_result_dir/domain.pddl"
        RUN_PROBLEM="$case_result_dir/problem.pddl"
        cp -f "$domain_file" "$RUN_DOMAIN"
        cp -f "$problem_file" "$RUN_PROBLEM"
    fi
}

resolve_command_args() {
    local domain_file="$1"
    local problem_file="$2"
    CMD=("$PYTHON_BIN" "$ROOT_DIR/conformant_planning.py" -d "$domain_file" -i "$problem_file" -p "$PLANNER")
    [[ -n "$SEARCH_ENGINE" ]] && CMD+=(-s "$SEARCH_ENGINE")
    if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
        CMD+=("${EXTRA_ARGS[@]}")
    fi
}

cleanup_root_transients() {
    rm -f "$ROOT_DIR/output.sas" \
          "$ROOT_DIR"/sas_plan* \
          "$ROOT_DIR"/output \
          "$ROOT_DIR"/plan.out \
          "$ROOT_DIR"/plan.ipc \
          "$ROOT_DIR"/elapsed.time \
          "$ROOT_DIR"/classical_plan 2>/dev/null || true
}

save_case_artifacts() {
    local case_result_dir="$1"
    local f
    for f in "$ROOT_DIR/output.sas" "$ROOT_DIR"/sas_plan* "$ROOT_DIR/output" "$ROOT_DIR/plan.out" "$ROOT_DIR/plan.ipc"; do
        if [[ -f "$f" ]]; then
            cp -f "$f" "$case_result_dir/$(basename "$f")" 2>/dev/null || true
        fi
    done
    # 当使用复制输入时，ICPCES 生成的 *_sample、*_plan、domain_conformant 等已经在 case_result_dir 内。
    # 这里额外列出文件，方便调试。
    find "$case_result_dir" -maxdepth 1 -type f | sort -V > "$case_result_dir/artifacts.txt" 2>/dev/null || true
}

classify_result() {
    local rc="$1"
    local log_file="$2"

    if [[ "$rc" -eq 124 || "$rc" -eq 137 ]]; then
        echo "TIMEOUT"; return 0
    fi
    if grep -Eiq "ModuleNotFoundError: No module named 'z3'|No module named z3" "$log_file"; then
        echo "MISSING_Z3"; return 0
    fi
    if grep -Eiq "ModuleNotFoundError: No module named 'options'|ModuleNotFoundError: No module named 'instantiate'" "$log_file"; then
        echo "MISSING_BRIDGE_MODULE"; return 0
    fi
    if grep -Eiq "Usage error occurred|Fast Downward.*usage|usage error" "$log_file"; then
        echo "FAST_DOWNWARD_USAGE_ERROR"; return 0
    fi
    if grep -Eiq "Cannot merge variables|Search stopped without finding a solution|no solution|No solution|unsolvable|Unsolvable" "$log_file"; then
        echo "NO_SOLUTION_OR_FAILED"; return 0
    fi
    if grep -Eiq "Traceback \(most recent call last\)|Exception|AttributeError|TypeError|ValueError|KeyError|IndexError|FileNotFoundError|Permission denied|cannot execute" "$log_file"; then
        echo "PYTHON_OR_RUNTIME_ERROR"; return 0
    fi
    if grep -Eiq "find a valid plan|plan length:" "$log_file"; then
        echo "FOUND_PLAN"; return 0
    fi
    if grep -Eiq "conformant planning time:|sampling time:|FD search time:" "$log_file"; then
        echo "FINISHED_NEED_CHECK"; return 0
    fi
    if [[ "$rc" -eq 0 ]]; then
        echo "EXIT0_NEED_CHECK"
    else
        echo "EXIT_CODE_${rc}"
    fi
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
    local pid="$1"
    local sig="$2"
    local child
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
    if [[ $FINALIZED -eq 1 ]]; then
        return 0
    fi
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
        if [[ -n "$CURRENT_CASE_LOG_FILE" ]]; then
            echo "[用户中断] 第二次 Ctrl+C，立即终止。" >> "$CURRENT_CASE_LOG_FILE"
        fi
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

wait_for_current_child() {
    local rc
    wait "$CURRENT_CHILD_PID"
    rc=$?
    return "$rc"
}

is_success_status() {
    [[ "$1" == "FOUND_PLAN" ]]
}

run_one_case() {
    local idx="$1"
    local bench_dir="$2"
    local domain_file="$3"
    local problem_file="$4"
    local case_name="$5"

    local case_id case_log_dir case_result_dir case_log_file start_ts end_ts elapsed rc status cmd_string
    case_id="$(case_id_for "$bench_dir" "$case_name")"
    case_log_dir="$LOG_ROOT/$(dirname "$case_id")"
    case_result_dir="$RESULT_ROOT/$case_id"
    case_log_file="$case_log_dir/$(basename "$case_id").log"
    mkdir -p "$case_log_dir" "$case_result_dir"

    prepare_case_inputs "$domain_file" "$problem_file" "$case_result_dir"
    resolve_command_args "$RUN_DOMAIN" "$RUN_PROBLEM"
    printf '%q ' "${CMD[@]}" > "$case_result_dir/command.txt"
    printf '\n' >> "$case_result_dir/command.txt"
    cmd_string="$(cat "$case_result_dir/command.txt")"

    if [[ $DRY_RUN -eq 1 ]]; then
        echo "[DRY-RUN] $idx/$DISCOVERED_CASES case=$case_id"
        echo "  domain=$domain_file"
        echo "  problem=$problem_file"
        echo "  run_domain=$RUN_DOMAIN"
        echo "  run_problem=$RUN_PROBLEM"
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
        echo "[求解器] ICPCES"
        echo "[ROOT_DIR] $ROOT_DIR"
        echo "[PYTHON_BIN] $PYTHON_BIN"
        echo "[TEST_ROOT] $TEST_ROOT"
        echo "[planner] $PLANNER"
        echo "[search_engine] ${SEARCH_ENGINE:-<not passed>}"
        echo "[benchmark_dir] $bench_dir"
        echo "[case_name] $case_name"
        echo "[source_domain] $domain_file"
        echo "[source_problem] $problem_file"
        echo "[run_domain] $RUN_DOMAIN"
        echo "[run_problem] $RUN_PROBLEM"
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
        export PYTHONPATH="$ROOT_DIR:${PYTHONPATH:-}"
        exec "$TIMEOUT_CMD" --signal=TERM --kill-after=10s "$TIMEOUT_SEC" "${CMD[@]}"
    ) >> "$case_log_file" 2>&1 &
    CURRENT_CHILD_PID=$!

    wait_for_current_child
    rc=$?
    CURRENT_CHILD_PID=""
    end_ts=$(date +%s)
    elapsed=$((end_ts - start_ts))

    status="$(classify_result "$rc" "$case_log_file")"
    {
        echo
        echo "[结束时间] $(date '+%F %T')"
        echo "[耗时秒] $elapsed"
        echo "[退出码] $rc"
        echo "[状态] $status"
    } >> "$case_log_file"

    cp -f "$case_log_file" "$case_result_dir/console.log"
    save_case_artifacts "$case_result_dir"
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

    echo "[进度] solver=ICPCES case=$case_id status=$status elapsed=${elapsed}s success=$SUCCESS_CASES failed=$FAILED_CASES total=$TOTAL_CASES/$DISCOVERED_CASES"

    CURRENT_CASE_ID=""
    CURRENT_CASE_LOG_FILE=""
    return 0
}

log_summary "[开始] ROOT_DIR=$ROOT_DIR"
log_summary "[开始] TEST_ROOT=$TEST_ROOT"
log_summary "[开始] PYTHON_BIN=$PYTHON_BIN"
log_summary "[开始] PLANNER=$PLANNER"
log_summary "[开始] SEARCH_ENGINE=${SEARCH_ENGINE:-<not passed>}"
log_summary "[开始] LOG_ROOT=$LOG_ROOT"
log_summary "[开始] RESULT_ROOT=$RESULT_ROOT"
log_summary "[开始] TIMEOUT_SEC=$TIMEOUT_SEC"
log_summary "[开始] MEM_LIMIT_GB=$MEM_LIMIT_GB"
log_summary "[开始] EXTRA=${EXTRA_ARGS[*]:-}"
[[ -n "$BENCHMARK_FILTER" ]] && log_summary "[过滤] benchmark=$BENCHMARK_FILTER"
[[ -n "$PROBLEM_FILTER" ]] && log_summary "[过滤] problem=$PROBLEM_FILTER"
log_summary ""

ensure_bridge_files
build_fast_downward

discover_cases
DISCOVERED_CASES=${#CASE_DOMAINS[@]}
declare -A BENCH_SET=()
for bd in "${CASE_BENCH_DIRS[@]}"; do BENCH_SET["$bd"]=1; done
DISCOVERED_BENCHMARKS=${#BENCH_SET[@]}

log_summary "[预扫描] 可运行benchmark数=$DISCOVERED_BENCHMARKS"
log_summary "[预扫描] 可运行用例总数=$DISCOVERED_CASES"
log_summary ""

echo "[开始] solver=ICPCES run_id=$RUN_ID planner=$PLANNER timeout=${TIMEOUT_SEC}s mem=${MEM_LIMIT_GB}GB"
echo "[开始] root=$ROOT_DIR"
echo "[开始] test_root=$TEST_ROOT"
echo "[开始] python=$PYTHON_BIN"
echo "[开始] search_engine=${SEARCH_ENGINE:-<not passed>}"
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
    if [[ $STOP_REQUESTED -eq 1 ]]; then
        break
    fi
done

finalize_summary
ELAPSED=$(($(date +%s) - START_TS))
echo "[完成] total=$TOTAL_CASES success=$SUCCESS_CASES failed=$FAILED_CASES elapsed=${ELAPSED}s"
echo "[完成] summary=$SUMMARY_LOG"
echo "[完成] result_root=$RESULT_ROOT"

if [[ $STOP_REQUESTED -eq 1 ]]; then
    exit "$STOP_REQUESTED_EXIT_CODE"
fi
if [[ $FAILED_CASES -gt 0 ]]; then
    exit 1
fi
exit 0
