#!/usr/bin/env bash
# Conformant-FF / FF 批量自动测试脚本
# 默认执行命令形态：
#   ./ff -o domain.pddl -f problem.pddl
#
# 说明：
# - 默认以脚本所在目录为项目根目录。
# - 默认测试根目录：<root>/Benchmark。
# - 每个测例复制 domain/problem 到独立结果目录后运行，避免 FF 相对路径和中间文件互相覆盖。
# - 每个测例保存 console.log、command.txt、输入文件备份、完整控制台日志。
# - 支持共享 domain 型 benchmark/domain.pddl + problem.pddl。
# - 支持 d/p 成对型 benchmark/d*.pddl + benchmark/p*.pddl。
# - 支持 instances 子目录：父目录 domain.pddl + instances/*.pddl。
# - 单用例默认超时 3600 秒，默认内存限制 16GB。
# - 成功判定：日志包含 "ff: found legal plan as follows" 或 "goal can be simplified to TRUE"。
# - 支持 Ctrl+C：第一次当前用例结束后退出，第二次立即终止。
# - 支持 Ctrl+B：终止当前用例并继续下一个测例；在 tmux 中可能会被 tmux 前缀键拦截。

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR"
TEST_ROOT=""
LOG_ROOT_BASE=""
RESULT_ROOT_BASE=""
FF_BIN=""

DEFAULT_TIMEOUT_SEC=300
TIMEOUT_SEC="$DEFAULT_TIMEOUT_SEC"
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
  --root DIR               项目根目录，默认：脚本所在目录
  -t, --test-root DIR      测试根目录，默认：<root>/Benchmark
  -l, --log-root DIR       日志根目录，默认：<root>/cff_test_logs
  -r, --result-root DIR    结果根目录，默认：<root>/cff_result_output_batch
  --ff-bin FILE            FF/CFF 可执行文件，默认：<root>/ff
  -b, --benchmark NAME     只运行指定 benchmark 目录名/路径组件，例如 blocks
  -p, --problem NAME       只运行指定 problem，例如 b4 / b4.pddl / problem / problem.pddl / 4
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
  跳过清单：  <log_root>/<run_id>/skipped_cases.txt
  异常清单：  <log_root>/<run_id>/anomalies.log

示例：
  ./run-test-cff.sh
  ./run-test-cff.sh -t ./Benchmark --timeout 3600 --mem-gb 16
  ./run-test-cff.sh -t ./Benchmark -b blocks -p b4
  ./run-test-cff.sh --ff-bin ./ff -t ./Benchmark --dry-run

单个测例等价命令形态：
  ./ff -o domain.pddl -f problem.pddl
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
        --ff-bin)
            FF_BIN="$2"; shift 2 ;;
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

[[ -z "$FF_BIN" ]] && FF_BIN="$ROOT_DIR/ff"
if [[ -f "$FF_BIN" ]]; then
    FF_BIN="$(abs_path_existing_file "$FF_BIN")"
fi

[[ -z "$TEST_ROOT" ]] && TEST_ROOT="$ROOT_DIR/Benchmark"
[[ -z "$LOG_ROOT_BASE" ]] && LOG_ROOT_BASE="$ROOT_DIR/cff_test_logs"
[[ -z "$RESULT_ROOT_BASE" ]] && RESULT_ROOT_BASE="$ROOT_DIR/cff_result_output_batch"

if [[ ! -x "$FF_BIN" ]]; then
    echo "[错误] 未找到可执行的 ff：$FF_BIN" >&2
    echo "[提示] 请确认 ff 已编译，或用 --ff-bin 指定路径。" >&2
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
SKIPPED_CASES_FILE="$LOG_ROOT/skipped_cases.txt"
ANOMALIES_LOG="$LOG_ROOT/anomalies.log"

mkdir -p "$LOG_ROOT" "$RESULT_ROOT"
: > "$SUMMARY_LOG"
: > "$FAILED_CASES_FILE"
: > "$SKIPPED_CASES_FILE"
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
    echo "[错误] 当前机器没有可用的 timeout/gtimeout 命令，无法执行超时控制。" >&2
    exit 1
fi

if command -v pgrep >/dev/null 2>&1; then
    HAVE_PGREP=1
else
    HAVE_PGREP=0
fi

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
    local rel part
    rel="${bench_dir#$TEST_ROOT/}"
    IFS='/' read -r -a parts <<< "$rel"
    for part in "${parts[@]}"; do
        if [[ "$part" == "$BENCHMARK_FILTER" ]]; then
            return 0
        fi
    done
    if [[ "$(basename "$bench_dir")" == "$BENCHMARK_FILTER" ]]; then
        return 0
    fi
    return 1
}

case_id_for() {
    local bench_dir="$1"
    local case_name="$2"
    local rel
    rel="${bench_dir#$TEST_ROOT/}"
    if [[ "$rel" == "$bench_dir" || "$rel" == "" ]]; then
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
        domain_*.pddl|d*.pddl|*_domain.pddl) return 1 ;;
        output.sas|output|belief|trans_file|finalplan|C_Plan|sas_plan*|planner.result) return 1 ;;
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
        domain_file=""
        if [[ -f "$bench_dir/domain.pddl" ]]; then
            domain_file="$bench_dir/domain.pddl"
        elif [[ -f "$bench_dir/domain_one.pddl" ]]; then
            domain_file="$bench_dir/domain_one.pddl"
        fi

        # 1) 共享 domain 型：domain.pddl/domain_one.pddl + 当前目录或 instances 子目录中的问题。
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

        # 2) 当前目录就是 instances：向父目录查找 domain。
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

        # 3) d*.pddl + p*.pddl 成对，例如 d4.pddl / p4.pddl 或 d10_10_dispose.pddl / p10_10_dispose.pddl。
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

        # 4) *_domain.pddl + 同前缀问题文件。
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

    done < <(find "$TEST_ROOT" \
        -path "$LOG_ROOT_BASE" -prune -o \
        -path "$RESULT_ROOT_BASE" -prune -o \
        -name cff_test_logs -prune -o \
        -name cff_result_output_batch -prune -o \
        -name t1_test_logs -prune -o \
        -name t1_result_output_batch -prune -o \
        -name ff_test_logs -prune -o \
        -type d -print0 | sort -z -V)
}

SUCCESS_CASES=0
FAILED_CASES=0
TIMEOUT_CASES=0
SKIPPED_CASES=0
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
SKIP_CURRENT_REQUESTED=0
CTRL_B_WATCHER_PID=""

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
    log_summary "[汇总] 其中超时=$TIMEOUT_CASES"
    log_summary "[汇总] 用户跳过=$SKIPPED_CASES"
    log_summary "[汇总] 总耗时=${elapsed}s"
    log_summary "[汇总] 日志目录=$LOG_ROOT"
    log_summary "[汇总] 结果目录=$RESULT_ROOT"
    log_summary "[汇总] 失败清单=$FAILED_CASES_FILE"
    log_summary "[汇总] 跳过清单=$SKIPPED_CASES_FILE"
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

handle_skip_current() {
    if [[ -z "$CURRENT_CHILD_PID" || -z "$CURRENT_CASE_ID" ]]; then
        return 0
    fi
    SKIP_CURRENT_REQUESTED=1
    echo
    echo "[跳过] 收到 Ctrl+B，正在终止当前用例并继续下一个：$CURRENT_CASE_ID"
    log_summary "[跳过] Ctrl+B 请求跳过当前用例：$CURRENT_CASE_ID"
    if [[ -n "$CURRENT_CASE_LOG_FILE" ]]; then
        echo "[用户跳过] Ctrl+B，终止当前用例并继续下一个。" >> "$CURRENT_CASE_LOG_FILE"
    fi
    terminate_current_child_now
}

trap 'handle_interrupt' INT TERM
trap 'handle_skip_current' USR1

start_ctrl_b_watcher() {
    if [[ ! -t 0 ]]; then
        return 0
    fi
    if ! { true < /dev/tty; } 2>/dev/null; then
        return 0
    fi
    (
        while true; do
            IFS= read -r -s -n 1 ch < /dev/tty 2>/dev/null || exit 0
            if [[ "$ch" == $'\002' ]]; then
                kill -USR1 $$ 2>/dev/null || exit 0
            fi
        done
    ) &
    CTRL_B_WATCHER_PID=$!
}

stop_ctrl_b_watcher() {
    if [[ -n "$CTRL_B_WATCHER_PID" ]]; then
        kill "$CTRL_B_WATCHER_PID" 2>/dev/null || true
        CTRL_B_WATCHER_PID=""
    fi
}

wait_for_current_child() {
    local rc
    wait "$CURRENT_CHILD_PID"
    rc=$?
    return "$rc"
}

classify_result() {
    local rc="$1"
    local log_file="$2"

    if [[ $SKIP_CURRENT_REQUESTED -eq 1 ]]; then
        echo "USER_SKIPPED"; return 0
    fi
    if [[ "$rc" -eq 124 || "$rc" -eq 137 ]]; then
        echo "TIMEOUT"; return 0
    fi
    if grep -Fq "ff: found legal plan as follows" "$log_file"; then
        echo "FOUND_PLAN"; return 0
    fi
    if grep -Fq "goal can be simplified to TRUE. The empty plan solves it" "$log_file"; then
        echo "FOUND_EMPTY_PLAN"; return 0
    fi
    if grep -Fq "best first search space empty! problem proven unsolvable" "$log_file"; then
        echo "PROVEN_UNSOLVABLE"; return 0
    fi
    if grep -Fq "goal can be simplified to FALSE. No plan will solve it" "$log_file"; then
        echo "GOAL_FALSE_NO_PLAN"; return 0
    fi
    if grep -Eiq "parse error|syntax error|Undeclared|undefined|can't open|cannot open|No such file|not found|Permission denied|Segmentation fault|core dumped|bad alloc" "$log_file"; then
        echo "ERROR"; return 0
    fi
    if [[ "$rc" -eq 0 ]]; then
        echo "EXIT0_NO_PLAN_MARKER"
    else
        echo "EXIT_CODE_${rc}"
    fi
}

is_success_status() {
    [[ "$1" == "FOUND_PLAN" || "$1" == "FOUND_EMPTY_PLAN" ]]
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

    cp -f "$domain_file" "$case_result_dir/domain.pddl" 2>/dev/null || true
    cp -f "$problem_file" "$case_result_dir/problem.pddl" 2>/dev/null || true

    CMD=("$FF_BIN" -o domain.pddl -f problem.pddl)
    printf '%q ' "${CMD[@]}" > "$case_result_dir/command.txt"
    printf '\n' >> "$case_result_dir/command.txt"
    cmd_string="$(cat "$case_result_dir/command.txt")"

    if [[ $DRY_RUN -eq 1 ]]; then
        echo "[DRY-RUN] $idx/$DISCOVERED_CASES case=$case_id"
        echo "  domain=$domain_file"
        echo "  problem=$problem_file"
        echo "  work_dir=$case_result_dir"
        echo "  command=cd $case_result_dir && $cmd_string"
        return 0
    fi

    TOTAL_CASES=$((TOTAL_CASES + 1))
    CURRENT_CASE_ID="$case_id"
    CURRENT_CASE_LOG_FILE="$case_log_file"
    SKIP_CURRENT_REQUESTED=0

    start_ts=$(date +%s)
    {
        echo "[开始时间] $(date '+%F %T')"
        echo "[求解器] Conformant-FF / FF"
        echo "[ROOT_DIR] $ROOT_DIR"
        echo "[FF_BIN] $FF_BIN"
        echo "[TEST_ROOT] $TEST_ROOT"
        echo "[benchmark_dir] $bench_dir"
        echo "[case_name] $case_name"
        echo "[domain_original] $domain_file"
        echo "[problem_original] $problem_file"
        echo "[work_dir] $case_result_dir"
        echo "[domain_runtime] $case_result_dir/domain.pddl"
        echo "[problem_runtime] $case_result_dir/problem.pddl"
        echo "[timeout_sec] $TIMEOUT_SEC"
        echo "[mem_limit_gb] $MEM_LIMIT_GB"
        echo "[mem_limit_kb_ulimit_v] $MEM_LIMIT_KB"
        echo "[command] cd $case_result_dir && ./ff -o domain.pddl -f problem.pddl"
        echo "[command_resolved] cd $case_result_dir && $cmd_string"
        echo "[success_marker] ff: found legal plan as follows"
        echo "[empty_plan_marker] goal can be simplified to TRUE. The empty plan solves it"
        echo
    } > "$case_log_file"

    (
        trap '' INT TERM USR1
        cd "$case_result_dir" || exit 1
        ulimit -v "$MEM_LIMIT_KB" 2>/dev/null || true
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

    cp -f "$case_log_file" "$case_result_dir/console.log" 2>/dev/null || true
    find "$case_result_dir" -maxdepth 1 -type f | sort -V > "$case_result_dir/artifacts.txt" 2>/dev/null || true

    if is_success_status "$status"; then
        SUCCESS_CASES=$((SUCCESS_CASES + 1))
        log_summary "  [完成] $case_id status=$status exit_code=$rc elapsed=${elapsed}s log=$case_log_file"
    elif [[ "$status" == "USER_SKIPPED" ]]; then
        SKIPPED_CASES=$((SKIPPED_CASES + 1))
        echo "$case_id USER_SKIPPED log=$case_log_file" >> "$SKIPPED_CASES_FILE"
        log_summary "  [跳过] $case_id status=$status exit_code=$rc elapsed=${elapsed}s log=$case_log_file"
    else
        FAILED_CASES=$((FAILED_CASES + 1))
        [[ "$status" == "TIMEOUT" ]] && TIMEOUT_CASES=$((TIMEOUT_CASES + 1))
        echo "$case_id  $status  exit_code=$rc log=$case_log_file" >> "$FAILED_CASES_FILE"
        log_summary "  [失败] $case_id status=$status exit_code=$rc elapsed=${elapsed}s log=$case_log_file"
        if [[ $CONTINUE_ON_ERROR -eq 0 ]]; then
            STOP_REQUESTED=1
            STOP_REQUESTED_EXIT_CODE=1
        fi
    fi

    echo "[进度] solver=CFF case=$case_id status=$status elapsed=${elapsed}s success=$SUCCESS_CASES failed=$FAILED_CASES skipped=$SKIPPED_CASES total=$TOTAL_CASES/$DISCOVERED_CASES"

    CURRENT_CASE_ID=""
    CURRENT_CASE_LOG_FILE=""
    SKIP_CURRENT_REQUESTED=0
    return 0
}

log_summary "[开始] ROOT_DIR=$ROOT_DIR"
log_summary "[开始] TEST_ROOT=$TEST_ROOT"
log_summary "[开始] FF_BIN=$FF_BIN"
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

echo "[开始] solver=CFF run_id=$RUN_ID timeout=${TIMEOUT_SEC}s mem=${MEM_LIMIT_GB}GB"
echo "[开始] root=$ROOT_DIR"
echo "[开始] test_root=$TEST_ROOT"
echo "[开始] ff=$FF_BIN"
echo "[开始] benchmark_count=$DISCOVERED_BENCHMARKS case_count=$DISCOVERED_CASES"
echo "[提示] Ctrl+B 可跳过当前测例继续下一个；Ctrl+C 第一次当前测例结束后退出，第二次立即终止。"

if [[ "$DISCOVERED_CASES" -eq 0 ]]; then
    echo "[错误] 没有发现可运行测例。请检查 -t、-b、-p 或 benchmark 结构。" >&2
    log_anomaly "[错误] 没有发现可运行测例。"
    finalize_summary
    exit 1
fi

start_ctrl_b_watcher
trap 'stop_ctrl_b_watcher; finalize_summary' EXIT

for i in "${!CASE_DOMAINS[@]}"; do
    n=$((i + 1))
    run_one_case "$n" "${CASE_BENCH_DIRS[$i]}" "${CASE_DOMAINS[$i]}" "${CASE_PROBLEMS[$i]}" "${CASE_NAMES[$i]}"
    if [[ $STOP_REQUESTED -eq 1 ]]; then
        break
    fi
done

finalize_summary
ELAPSED=$(($(date +%s) - START_TS))
echo "[完成] total=$TOTAL_CASES success=$SUCCESS_CASES failed=$FAILED_CASES skipped=$SKIPPED_CASES elapsed=${ELAPSED}s"
echo "[完成] summary=$SUMMARY_LOG"
echo "[完成] result_root=$RESULT_ROOT"

if [[ $STOP_REQUESTED -eq 1 ]]; then
    exit "$STOP_REQUESTED_EXIT_CODE"
fi
if [[ $FAILED_CASES -gt 0 ]]; then
    exit 1
fi
exit 0
