#!/usr/bin/env bash
# gCPCES / CPCES 批量自动测试脚本
# 参考 T1 自动测试脚本结构改写。
# 默认执行命令：
#   ./cpces2 -o <domain.pddl> -f <problem.pddl>
#
# 说明：
# - CPCES/cpces2 默认不会稳定地产生单独结果文件；本脚本只保存完整控制台输出。
# - 每个测例保存一个独立 console.log，同时在日志目录保存同内容 .log。
# - 默认以脚本所在目录为项目根目录。
# - 默认测试根目录：<root>/benchmarks。
# - 支持多类 benchmark 命名：
#     1) 共享 domain 型：benchmark/domain.pddl + 其他 *.pddl
#     2) domain_one 型： benchmark/domain_one.pddl + 其他 *.pddl 或 instances/*.pddl
#     3) instances 型： 父目录有 domain.pddl/domain_one.pddl，子目录 instances/*.pddl
#     4) d/p 成对型：  benchmark/d*.pddl 与 benchmark/p*.pddl 一一配对
#     5) generated 型：domain_<suffix>.pddl 与 instance_<suffix>.pddl 一一配对
# - 支持 timeout、内存限制、benchmark/problem 过滤。
# - 支持 Ctrl+C 优雅退出：第一次请求当前用例结束后退出，第二次立即终止。
#
# 常用命令：
#   ./run-test-gcpces.sh -t ./benchmarks -b grid -p sample
#   ./run-test-gcpces.sh -t ./benchmarks/ijcai17 -b blocksworld -p p01
#   ./run-test-gcpces.sh -t ./benchmarks/ijcai17 -b look-grab -p p_4_1_1
#   ./run-test-gcpces.sh -t ./benchmarks --timeout 3600 --mem-gb 16

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR"
CPCES_BIN=""
TEST_ROOT=""
LOG_ROOT_BASE=""
RESULT_ROOT_BASE=""

# 默认严格复现你已确认可运行的命令：./cpces2 -o ... -f ...
# 如需额外参数，可显式传 --cp / --ref / --pm / --extra。
CLASSICAL_PLANNER=""
REF_METHOD=""
PLAN_METHOD=""
EXTRA_ARGS=()

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
  --root DIR               CPCES 项目根目录，默认：脚本所在目录
  -t, --test-root DIR      测试根目录，默认：<root>/benchmarks
  -l, --log-root DIR       日志根目录，默认：<root>/gcpces_test_logs
  -r, --result-root DIR    结果根目录，默认：<root>/gcpces_result_output_batch
  --cpces-bin FILE         cpces2 可执行文件，默认：<root>/cpces2
  -b, --benchmark NAME     只运行指定 benchmark 目录名，例如 grid / blocksworld / look-grab
  -p, --problem NAME       只运行指定 problem，可写成：
                           sample / sample.pddl / p01 / p01.pddl / p_4_1_1 / 4_1_1
  --run-id ID              指定本轮运行 ID
  --timeout SEC            单用例超时秒数，默认：3600
  --mem-gb GB              单用例内存限制 GB，默认：16
  --cp NAME                传给 cpces2 的 -cp，例如 ff / mpc；默认不传，复现 cpces2 默认行为
  --ref NAME               传给 cpces2 的 -ref，例如 greedy / refined / heuristic；默认不传
  --pm NAME                传给 cpces2 的 -pm，例如 replanning / macro；默认不传
  --extra "ARGS"           额外原样追加给 cpces2 的参数，例如 --extra "-debug 1 -ub 100"
  --dry-run                只列出将运行的测例，不实际执行
  --stop-on-error          遇到失败立即停止
  -h, --help               显示帮助

输出：
  控制台日志：<log_root>/<run_id>/<benchmark>/<case>.log
  控制台备份：<result_root>/<run_id>/<benchmark>/<case>/console.log
  命令记录：  <result_root>/<run_id>/<benchmark>/<case>/command.txt
  汇总日志：  <log_root>/<run_id>/summary.log
  失败清单：  <log_root>/<run_id>/failed_cases.txt
  异常清单：  <log_root>/<run_id>/anomalies.log

示例：
  ./run-test-gcpces.sh -t ./benchmarks -b grid -p sample
  ./run-test-gcpces.sh -t ./benchmarks/ijcai17 -b blocksworld -p p01
  ./run-test-gcpces.sh -t ./benchmarks/ijcai17 -b look-grab -p p_4_1_1
  ./run-test-gcpces.sh -t ./benchmarks --timeout 3600 --mem-gb 16
  ./run-test-gcpces.sh -t ./benchmarks --cp ff --ref greedy --pm replanning
USAGE
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --root)
            ROOT_DIR="$2"
            shift 2
            ;;
        -t|--test-root)
            TEST_ROOT="$2"
            shift 2
            ;;
        -l|--log-root)
            LOG_ROOT_BASE="$2"
            shift 2
            ;;
        -r|--result-root)
            RESULT_ROOT_BASE="$2"
            shift 2
            ;;
        --cpces-bin)
            CPCES_BIN="$2"
            shift 2
            ;;
        -b|--benchmark)
            BENCHMARK_FILTER="$2"
            shift 2
            ;;
        -p|--problem)
            PROBLEM_FILTER="$2"
            shift 2
            ;;
        --run-id)
            RUN_ID="$2"
            shift 2
            ;;
        --timeout)
            TIMEOUT_SEC="$2"
            shift 2
            ;;
        --mem-gb)
            MEM_LIMIT_GB="$2"
            shift 2
            ;;
        --cp)
            CLASSICAL_PLANNER="$2"
            shift 2
            ;;
        --ref)
            REF_METHOD="$2"
            shift 2
            ;;
        --pm)
            PLAN_METHOD="$2"
            shift 2
            ;;
        --extra)
            # shellcheck disable=SC2206
            EXTRA_ARGS=($2)
            shift 2
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --stop-on-error)
            CONTINUE_ON_ERROR=0
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "[错误] 未知参数：$1" >&2
            usage
            exit 1
            ;;
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

[[ -z "$CPCES_BIN" ]] && CPCES_BIN="$ROOT_DIR/cpces2"
if [[ -f "$CPCES_BIN" ]]; then
    CPCES_BIN="$(abs_path_existing_file "$CPCES_BIN")"
fi

[[ -z "$TEST_ROOT" ]] && TEST_ROOT="$ROOT_DIR/benchmarks"
[[ -z "$LOG_ROOT_BASE" ]] && LOG_ROOT_BASE="$ROOT_DIR/gcpces_test_logs"
[[ -z "$RESULT_ROOT_BASE" ]] && RESULT_ROOT_BASE="$ROOT_DIR/gcpces_result_output_batch"

if [[ ! -x "$CPCES_BIN" ]]; then
    echo "[错误] 未找到可执行的 cpces2：$CPCES_BIN" >&2
    echo "[提示] 请确认 cpces2 已编译并 chmod +x，或用 --cpces-bin 指定路径。" >&2
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
        echo "timeout"
        return 0
    fi
    if command -v gtimeout >/dev/null 2>&1; then
        echo "gtimeout"
        return 0
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

log_summary() {
    printf '%s\n' "$*" >> "$SUMMARY_LOG"
}

log_anomaly() {
    printf '%s\n' "$*" >> "$ANOMALIES_LOG"
    printf '%s\n' "$*" >> "$SUMMARY_LOG"
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
    if [[ "$f_noext" == *.pddl ]]; then
        f_noext="${f_noext%.pddl}"
    fi

    if [[ "$file_base" == "$filter" || "$case_name" == "$filter" || "$case_name" == "$f_noext" ]]; then
        return 0
    fi

    # p_4_1_1 可以用 4_1_1 过滤；p2-1 可以用 2-1 过滤。
    if [[ -n "$pair_suffix" && ( "$pair_suffix" == "$filter" || "$pair_suffix" == "$f_noext" ) ]]; then
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
            printf '%s\n' "$dir/domain.pddl"
            return 0
        fi
        if [[ -f "$dir/domain_one.pddl" ]]; then
            printf '%s\n' "$dir/domain_one.pddl"
            return 0
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
        *domain_conformant*|*_sample|*_sample_plan) return 1 ;;
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
            while IFS= read -r -d '' problem_file; do
                problem_base="$(basename "$problem_file")"
                is_problem_candidate "$problem_base" || continue
                case_name="$(strip_case_ext "$problem_base")"
                append_case "$bench_dir" "$domain_file" "$problem_file" "$case_name" ""
            done < <(find "$bench_dir" -maxdepth 1 -type f \( -name '*.pddl' -o -name '*.pddl~' \) -print0 | sort -z -V)
        fi

        # 2) instances/unsat_instances 等子目录：使用最近父目录 domain.pddl/domain_one.pddl。
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
                case_name="p$key"
                append_case "$bench_dir" "${d_map[$key]}" "${p_map[$key]}" "$case_name" "$key"
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

resolve_command_args() {
    local domain_file="$1"
    local problem_file="$2"
    CMD=("$CPCES_BIN" -o "$domain_file" -f "$problem_file")
    [[ -n "$CLASSICAL_PLANNER" ]] && CMD+=(-cp "$CLASSICAL_PLANNER")
    [[ -n "$REF_METHOD" ]] && CMD+=(-ref "$REF_METHOD")
    [[ -n "$PLAN_METHOD" ]] && CMD+=(-pm "$PLAN_METHOD")
    if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
        CMD+=("${EXTRA_ARGS[@]}")
    fi
}

classify_result() {
    local rc="$1"
    local log_file="$2"

    if [[ "$rc" -eq 124 || "$rc" -eq 137 ]]; then
        echo "TIMEOUT"
        return 0
    fi
    if grep -Eiq "UnsatisfiedLinkError|NoClassDefFoundError|ClassNotFoundException|Exception in thread|java\.lang\.|libz3|no z3|Z3Exception" "$log_file"; then
        echo "JAVA_OR_Z3_ERROR"
        return 0
    fi
    if grep -Eiq "Parsing failed|ParseException|syntax error|PDDL.*error|could not parse|parser" "$log_file"; then
        echo "PARSE_OR_PDDL_ERROR"
        return 0
    fi
    if grep -Eiq "Problem Unsolvable|Unsolvable|No plan found|no plan" "$log_file"; then
        echo "UNSOLVABLE_OR_NO_PLAN"
        return 0
    fi
    if grep -Eq "\|pi\|:" "$log_file"; then
        echo "FOUND_PLAN"
        return 0
    fi
    if grep -Eiq "Conformant Planning Time|Sampling Time|Generation Time" "$log_file"; then
        echo "FINISHED_NEED_CHECK"
        return 0
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
    case "$1" in
        FOUND_PLAN|UNSOLVABLE_OR_NO_PLAN|FINISHED_NEED_CHECK|EXIT0_NEED_CHECK) return 0 ;;
        *) return 1 ;;
    esac
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

    resolve_command_args "$domain_file" "$problem_file"
    printf '%q ' "${CMD[@]}" > "$case_result_dir/command.txt"
    printf '\n' >> "$case_result_dir/command.txt"
    cmd_string="$(cat "$case_result_dir/command.txt")"

    if [[ $DRY_RUN -eq 1 ]]; then
        echo "[DRY-RUN] $idx/$DISCOVERED_CASES case=$case_id"
        echo "  domain=$domain_file"
        echo "  problem=$problem_file"
        echo "  command=$cmd_string"
        return 0
    fi

    TOTAL_CASES=$((TOTAL_CASES + 1))
    CURRENT_CASE_ID="$case_id"
    CURRENT_CASE_LOG_FILE="$case_log_file"

    start_ts=$(date +%s)
    {
        echo "[开始时间] $(date '+%F %T')"
        echo "[求解器] gCPCES/CPCES"
        echo "[ROOT_DIR] $ROOT_DIR"
        echo "[CPCES_BIN] $CPCES_BIN"
        echo "[TEST_ROOT] $TEST_ROOT"
        echo "[benchmark_dir] $bench_dir"
        echo "[case_name] $case_name"
        echo "[domain] $domain_file"
        echo "[problem] $problem_file"
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
        export LD_LIBRARY_PATH="$ROOT_DIR/libs:${LD_LIBRARY_PATH:-}"
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
    cp -f "$domain_file" "$case_result_dir/domain.pddl" 2>/dev/null || true
    cp -f "$problem_file" "$case_result_dir/problem.pddl" 2>/dev/null || true

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

    echo "[进度] solver=gCPCES case=$case_id status=$status elapsed=${elapsed}s success=$SUCCESS_CASES failed=$FAILED_CASES total=$TOTAL_CASES/$DISCOVERED_CASES"

    CURRENT_CASE_ID=""
    CURRENT_CASE_LOG_FILE=""
    return 0
}

log_summary "[开始] ROOT_DIR=$ROOT_DIR"
log_summary "[开始] TEST_ROOT=$TEST_ROOT"
log_summary "[开始] CPCES_BIN=$CPCES_BIN"
log_summary "[开始] LOG_ROOT=$LOG_ROOT"
log_summary "[开始] RESULT_ROOT=$RESULT_ROOT"
log_summary "[开始] TIMEOUT_SEC=$TIMEOUT_SEC"
log_summary "[开始] MEM_LIMIT_GB=$MEM_LIMIT_GB"
log_summary "[开始] EXTRA cp=$CLASSICAL_PLANNER ref=$REF_METHOD pm=$PLAN_METHOD extra=${EXTRA_ARGS[*]:-}"
[[ -n "$BENCHMARK_FILTER" ]] && log_summary "[过滤] benchmark=$BENCHMARK_FILTER"
[[ -n "$PROBLEM_FILTER" ]] && log_summary "[过滤] problem=$PROBLEM_FILTER"
log_summary ""

discover_cases
DISCOVERED_CASES=${#CASE_DOMAINS[@]}
# 统计 benchmark 数：按 bench dir 去重。
declare -A BENCH_SET=()
for bd in "${CASE_BENCH_DIRS[@]}"; do BENCH_SET["$bd"]=1; done
DISCOVERED_BENCHMARKS=${#BENCH_SET[@]}

log_summary "[预扫描] 可运行benchmark数=$DISCOVERED_BENCHMARKS"
log_summary "[预扫描] 可运行用例总数=$DISCOVERED_CASES"
log_summary ""

echo "[开始] solver=gCPCES run_id=$RUN_ID timeout=${TIMEOUT_SEC}s mem=${MEM_LIMIT_GB}GB"
echo "[开始] root=$ROOT_DIR"
echo "[开始] test_root=$TEST_ROOT"
echo "[开始] cpces_bin=$CPCES_BIN"
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
