#!/usr/bin/env bash
# CE-planner 多候选规划器批量测试脚本
#
# 功能：
#   1. 通过 --solver 指定候选计划求解器；
#   2. Ctrl+C：立即终止当前测例并结束整个批量测试；
#   3. Ctrl+B：立即终止当前测例，记录为 USER_SKIP，并继续下一个测例；
#   4. 每个测例独立限制总运行时间和虚拟内存；
#   5. 默认单测例 3600 秒、16 GiB；
#   6. 支持指定 benchmark 根目录、一个或多个 benchmark、单个 problem；
#   7. 兼容两种 benchmark 布局：
#      - <benchmark>/domain.pddl + 多个 problem.pddl
#      - <benchmark>/d*.pddl 与 p*.pddl 成对
#   8. 以 CE-planner 最终接受标志判定成功，不仅依赖进程退出码。
#
# 运行环境：Linux + Bash 4+ + GNU timeout。

set -u
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR"
BENCH_ROOT=""
LOG_ROOT_BASE=""
RESULT_ROOT_BASE=""
RUN_ID=""

SOLVER="t1"
PLAN_SCRIPT_OVERRIDE=""
PLAN_SCRIPT=""
DISPLAY_FLAG="false"
TIMEOUT_SEC=300
MEMORY_LIMIT="16G"
MEMORY_LIMIT_KB=0
CONTINUE_ON_ERROR=1
BUILD_FIRST=0

BENCHMARK_FILTERS=()
PROBLEM_FILTER=""
CASE_SELECTOR=""

SUCCESS_MARKER="[IGC-CEGIS] no counterexample found; final conformant plan accepted."

TIMEOUT_CMD=""
TIME_CMD=""
HAVE_SETSID=0
HAVE_PGREP=0
HAVE_PKILL=0
INTERACTIVE_KEYS=0

usage() {
    cat <<'USAGE'
用法：
  run-test-ce-planner.sh [选项]

核心选项：
  -s, --solver NAME          候选计划求解器，默认：t1
                             支持：t1, cff, cnf, dnf, pip, cpah,
                                   igc, gc-lama, gcpces, icpces
  --plan-script FILE         自定义 CE-planner 启动脚本；设置后覆盖 --solver 映射
  --root DIR                 CE-planner 项目根目录，默认：脚本所在目录
  -t, --bench-root DIR       所有 benchmark 所在目录，默认：<root>/test

筛选选项：
  -b, --benchmark NAME       只测试指定 benchmark。可重复，也可逗号分隔：
                             -b blocks -b dispose
                             -b blocks,dispose
  -p, --problem NAME         只测试指定测例，例如：b3、b3.pddl、p2-2、2-2
  --case BENCH/PROBLEM       同时指定 benchmark 和单个测例，例如：blocks/b3

资源限制：
  --timeout SEC              每个测例总运行时间上限，默认：3600 秒
  --memory SIZE              每个测例虚拟内存上限，默认：16G
                             支持 K/M/G/T；无单位时按 MiB，例如：8192、8G

输出选项：
  -l, --log-root DIR         日志根目录，默认：<root>/test_logs_ce
  -r, --result-root DIR      结果根目录，默认：<root>/result_output_batch_ce
  --run-id ID                指定本轮运行 ID，默认：<solver>_YYYYmmdd_HHMMSS
  -d, --display FLAG         传给 plan-cegis-* 的第 4 个参数，默认：false
  --success-marker TEXT      自定义最终成功标志

控制选项：
  --build-first              测试前先在项目根目录运行 ./build
  --stop-on-error            普通失败、超时或内存失败后停止整批测试
  -h, --help                 显示帮助

运行时快捷键：
  Ctrl+C                     立即结束当前测例，并结束整个批量测试
  Ctrl+B                     立即跳过当前测例，继续下一个测例

目录结构：
  日志：<log_root>/<run_id>/<benchmark>/<case>.log
  结果：<result_root>/<run_id>/<benchmark>/<case>/result.plan
  汇总：<log_root>/<run_id>/summary.log

示例：
  # 使用 T1 测试全部 benchmark
  ./run-test-ce-planner.sh --solver t1

  # 使用 CFF，单例 1800 秒、8G，测试 blocks
  ./run-test-ce-planner.sh -s cff -b blocks --timeout 1800 --memory 8G

  # 使用 gCPCES，只测试 blocks/b3
  ./run-test-ce-planner.sh -s gcpces --case blocks/b3

  # 指定外部 benchmark 根目录，测试两个领域
  ./run-test-ce-planner.sh -s icpces \
      --bench-root /data/Conformant-Benchmarks \
      -b blocks,dispose
USAGE
}

fatal() {
    echo "[错误] $*" >&2
    exit 1
}

need_arg() {
    local opt="$1"
    local value="${2:-}"
    [[ -n "$value" ]] || fatal "$opt 缺少参数。"
}

add_benchmark_filters() {
    local raw="$1"
    local item
    local old_ifs="$IFS"
    IFS=','
    for item in $raw; do
        item="${item#./}"
        item="${item%/}"
        [[ -z "$item" || "$item" == "all" || "$item" == "ALL" ]] && continue
        BENCHMARK_FILTERS+=("$item")
    done
    IFS="$old_ifs"
}

normalize_solver() {
    local value="${1,,}"
    value="${value//_/-}"
    case "$value" in
        t1) echo "t1" ;;
        cff|ff|conformant-ff) echo "cff" ;;
        cnf|cnf-planner) echo "cnf" ;;
        dnf|dnf-planner) echo "dnf" ;;
        pip|pip-planner) echo "pip" ;;
        cpah|cpa-h|cpah-planner) echo "cpah" ;;
        igc|igc-origin|original-igc) echo "igc" ;;
        gc|gc-lama|gclama) echo "gc-lama" ;;
        gcpces|g-cpces|cpces) echo "gcpces" ;;
        icpces|i-cpces) echo "icpces" ;;
        *) return 1 ;;
    esac
}

solver_plan_script_name() {
    case "$1" in
        t1) echo "plan-cegis-t1" ;;
        cff) echo "plan-cegis-cff" ;;
        cnf) echo "plan-cegis-cnf" ;;
        dnf) echo "plan-cegis-dnf" ;;
        pip) echo "plan-cegis-pip" ;;
        cpah) echo "plan-cegis-cpah" ;;
        igc) echo "plan-cegis-igc" ;;
        gc-lama) echo "plan-cegis-gc-lama" ;;
        gcpces) echo "plan-cegis-gcpces" ;;
        icpces) echo "plan-cegis-icpces" ;;
        *) return 1 ;;
    esac
}

parse_memory_to_kb() {
    local raw="${1^^}"
    local number unit

    raw="${raw//IB/}"
    raw="${raw//B/}"

    if [[ "$raw" =~ ^([0-9]+)([KMGT]?)$ ]]; then
        number="${BASH_REMATCH[1]}"
        unit="${BASH_REMATCH[2]}"
    else
        return 1
    fi

    case "$unit" in
        "") echo $((number * 1024)) ;;              # 无单位：MiB -> KiB
        K)  echo "$number" ;;
        M)  echo $((number * 1024)) ;;
        G)  echo $((number * 1024 * 1024)) ;;
        T)  echo $((number * 1024 * 1024 * 1024)) ;;
        *) return 1 ;;
    esac
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --root)
            need_arg "$1" "${2:-}"
            ROOT_DIR="$2"
            shift 2
            ;;
        -t|--bench-root|--test-root)
            need_arg "$1" "${2:-}"
            BENCH_ROOT="$2"
            shift 2
            ;;
        -l|--log-root)
            need_arg "$1" "${2:-}"
            LOG_ROOT_BASE="$2"
            shift 2
            ;;
        -r|--result-root)
            need_arg "$1" "${2:-}"
            RESULT_ROOT_BASE="$2"
            shift 2
            ;;
        -s|--solver|--planner)
            need_arg "$1" "${2:-}"
            SOLVER="$2"
            shift 2
            ;;
        --plan-script)
            need_arg "$1" "${2:-}"
            PLAN_SCRIPT_OVERRIDE="$2"
            shift 2
            ;;
        -b|--benchmark)
            need_arg "$1" "${2:-}"
            add_benchmark_filters "$2"
            shift 2
            ;;
        -p|--problem)
            need_arg "$1" "${2:-}"
            PROBLEM_FILTER="$2"
            shift 2
            ;;
        --case)
            need_arg "$1" "${2:-}"
            CASE_SELECTOR="$2"
            shift 2
            ;;
        --timeout)
            need_arg "$1" "${2:-}"
            TIMEOUT_SEC="$2"
            shift 2
            ;;
        --memory)
            need_arg "$1" "${2:-}"
            MEMORY_LIMIT="$2"
            shift 2
            ;;
        --run-id)
            need_arg "$1" "${2:-}"
            RUN_ID="$2"
            shift 2
            ;;
        -d|--display)
            need_arg "$1" "${2:-}"
            DISPLAY_FLAG="$2"
            shift 2
            ;;
        --success-marker)
            need_arg "$1" "${2:-}"
            SUCCESS_MARKER="$2"
            shift 2
            ;;
        --build-first)
            BUILD_FIRST=1
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
            fatal "未知参数：$1。使用 --help 查看说明。"
            ;;
    esac
done

if [[ -n "$CASE_SELECTOR" ]]; then
    if [[ "$CASE_SELECTOR" == */* ]]; then
        case_bench="${CASE_SELECTOR%%/*}"
        case_problem="${CASE_SELECTOR#*/}"
        BENCHMARK_FILTERS=()
        add_benchmark_filters "$case_bench"
        PROBLEM_FILTER="$case_problem"
    else
        PROBLEM_FILTER="$CASE_SELECTOR"
    fi
fi

NORMALIZED_SOLVER="$(normalize_solver "$SOLVER" 2>/dev/null || true)"
[[ -n "$NORMALIZED_SOLVER" ]] || fatal "不支持的候选规划器：$SOLVER"
SOLVER="$NORMALIZED_SOLVER"

[[ "$TIMEOUT_SEC" =~ ^[0-9]+$ && "$TIMEOUT_SEC" -gt 0 ]] \
    || fatal "--timeout 必须是正整数秒数。"

MEMORY_LIMIT_KB="$(parse_memory_to_kb "$MEMORY_LIMIT" 2>/dev/null || true)"
[[ "$MEMORY_LIMIT_KB" =~ ^[0-9]+$ && "$MEMORY_LIMIT_KB" -gt 0 ]] \
    || fatal "--memory 格式无效：$MEMORY_LIMIT。示例：16G、8192M、8388608K。"

ROOT_DIR="$(cd "$ROOT_DIR" 2>/dev/null && pwd)" \
    || fatal "无法解析项目根目录：$ROOT_DIR"

[[ -z "$BENCH_ROOT" ]] && BENCH_ROOT="$ROOT_DIR/test"
[[ -z "$LOG_ROOT_BASE" ]] && LOG_ROOT_BASE="$ROOT_DIR/test_logs_ce"
[[ -z "$RESULT_ROOT_BASE" ]] && RESULT_ROOT_BASE="$ROOT_DIR/result_output_batch_ce"
[[ -z "$RUN_ID" ]] && RUN_ID="${SOLVER}_$(date +%Y%m%d_%H%M%S)"

[[ -d "$BENCH_ROOT" ]] || fatal "benchmark 根目录不存在：$BENCH_ROOT"
BENCH_ROOT="$(cd "$BENCH_ROOT" 2>/dev/null && pwd)" \
    || fatal "无法解析 benchmark 根目录。"

mkdir -p "$LOG_ROOT_BASE" "$RESULT_ROOT_BASE" || fatal "无法创建日志或结果根目录。"
LOG_ROOT_BASE="$(cd "$LOG_ROOT_BASE" && pwd)"
RESULT_ROOT_BASE="$(cd "$RESULT_ROOT_BASE" && pwd)"

if [[ -n "$PLAN_SCRIPT_OVERRIDE" ]]; then
    if [[ "$PLAN_SCRIPT_OVERRIDE" != /* ]]; then
        PLAN_SCRIPT_OVERRIDE="$ROOT_DIR/$PLAN_SCRIPT_OVERRIDE"
    fi
    PLAN_SCRIPT="$PLAN_SCRIPT_OVERRIDE"
else
    PLAN_SCRIPT="$ROOT_DIR/$(solver_plan_script_name "$SOLVER")"
fi

[[ -f "$PLAN_SCRIPT" ]] || fatal "未找到候选规划器启动脚本：$PLAN_SCRIPT"
[[ -f "$ROOT_DIR/plan-cegis" ]] || fatal "项目根目录缺少 plan-cegis：$ROOT_DIR/plan-cegis"
[[ -f "$ROOT_DIR/plan" ]] || fatal "项目根目录缺少 plan：$ROOT_DIR/plan"

TIMEOUT_CMD="$(command -v timeout 2>/dev/null || command -v gtimeout 2>/dev/null || true)"
[[ -n "$TIMEOUT_CMD" ]] || fatal "系统缺少 timeout/gtimeout，无法限制单测例时间。"

[[ -x /usr/bin/time ]] && TIME_CMD="/usr/bin/time"
command -v setsid >/dev/null 2>&1 && HAVE_SETSID=1
command -v pgrep >/dev/null 2>&1 && HAVE_PGREP=1
command -v pkill >/dev/null 2>&1 && HAVE_PKILL=1
[[ -t 0 ]] && INTERACTIVE_KEYS=1

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

CASE_RUNNER="$LOG_ROOT/.case-runner.sh"
cat > "$CASE_RUNNER" <<'CASE_RUNNER_EOF'
#!/usr/bin/env bash
set -u
root_dir=$1
memory_kb=$2
timeout_cmd=$3
timeout_sec=$4
plan_script=$5
domain_file=$6
problem_file=$7
result_file=$8
display_flag=$9
time_cmd=${10:-}

cd "$root_dir" || exit 126
ulimit -v "$memory_kb" || {
    echo "[RESOURCE] failed to set ulimit -v=$memory_kb" >&2
    exit 125
}

if [[ -n "$time_cmd" ]]; then
    exec "$time_cmd" -v "$timeout_cmd" --signal=TERM --kill-after=10s "$timeout_sec" \
        bash "$plan_script" "$domain_file" "$problem_file" "$result_file" "$display_flag"
else
    exec "$timeout_cmd" --signal=TERM --kill-after=10s "$timeout_sec" \
        bash "$plan_script" "$domain_file" "$problem_file" "$result_file" "$display_flag"
fi
CASE_RUNNER_EOF
chmod 700 "$CASE_RUNNER"

log_summary() {
    printf '%s\n' "$*" >> "$SUMMARY_LOG"
}

log_anomaly() {
    printf '%s\n' "$*" | tee -a "$ANOMALIES_LOG" >> "$SUMMARY_LOG"
}

benchmark_selected() {
    local name="$1"
    local filter
    [[ ${#BENCHMARK_FILTERS[@]} -eq 0 ]] && return 0
    for filter in "${BENCHMARK_FILTERS[@]}"; do
        [[ "$name" == "$filter" || "$name" == "$(basename "$filter")" ]] && return 0
    done
    return 1
}

matches_problem_filter() {
    local filter="$1"
    local case_name="$2"
    local problem_base="$3"
    local pair_suffix="$4"
    local f_noext

    [[ -z "$filter" ]] && return 0

    f_noext="${filter##*/}"
    f_noext="${f_noext%.pddl}"

    [[ "$problem_base" == "$filter" ]] && return 0
    [[ "$problem_base" == "${filter##*/}" ]] && return 0
    [[ "$case_name" == "$filter" || "$case_name" == "$f_noext" ]] && return 0
    [[ -n "$pair_suffix" && ( "$pair_suffix" == "$filter" || "$pair_suffix" == "$f_noext" ) ]] && return 0
    return 1
}

get_selected_case_count_for_benchmark() {
    local bench_dir="$1"
    local bench_name count=0
    local domain_pddl problem_file problem_basename case_name
    local d_file p_file d_base p_base d_key p_key key

    bench_name="$(basename "$bench_dir")"
    benchmark_selected "$bench_name" || { echo 0; return 0; }

    domain_pddl="$bench_dir/domain.pddl"
    if [[ -f "$domain_pddl" ]]; then
        while IFS= read -r -d '' problem_file; do
            problem_basename="$(basename "$problem_file")"
            case_name="${problem_basename%.pddl}"
            if matches_problem_filter "$PROBLEM_FILTER" "$case_name" "$problem_basename" ""; then
                count=$((count + 1))
            fi
        done < <(find "$bench_dir" -maxdepth 1 -type f -name '*.pddl' ! -name 'domain.pddl' -print0 | sort -zV)
    else
        local -A d_map=()
        local -A p_map=()

        while IFS= read -r -d '' d_file; do
            d_base="$(basename "$d_file")"
            d_key="${d_base#d}"
            d_key="${d_key%.pddl}"
            d_map["$d_key"]="$d_file"
        done < <(find "$bench_dir" -maxdepth 1 -type f -name 'd*.pddl' -print0 | sort -zV)

        while IFS= read -r -d '' p_file; do
            p_base="$(basename "$p_file")"
            p_key="${p_base#p}"
            p_key="${p_key%.pddl}"
            p_map["$p_key"]="$p_file"
        done < <(find "$bench_dir" -maxdepth 1 -type f -name 'p*.pddl' -print0 | sort -zV)

        while IFS= read -r key; do
            [[ -z "$key" ]] && continue
            if [[ -n "${p_map[$key]:-}" ]]; then
                problem_basename="$(basename "${p_map[$key]}")"
                case_name="p$key"
                if matches_problem_filter "$PROBLEM_FILTER" "$case_name" "$problem_basename" "$key"; then
                    count=$((count + 1))
                fi
            fi
        done < <(printf '%s\n' "${!d_map[@]}" | sort -V)
    fi

    echo "$count"
}

FINALIZED=0
ABORT_REQUESTED=0
STOP_AFTER_CURRENT=0
CURRENT_CASE_SKIP_REQUESTED=0
CURRENT_CASE_ABORT_REQUESTED=0
CURRENT_CHILD_PID=""
CURRENT_SESSION_ID=""
CURRENT_CASE_NAME=""
CURRENT_BENCHMARK_NAME=""
CURRENT_CASE_LOG_FILE=""

DISCOVERED_BENCHMARKS=0
DISCOVERED_CASES=0
TOTAL_BENCHMARKS=0
TOTAL_CASES=0
SUCCESS_CASES=0
FAILED_CASES=0
TIMEOUT_CASES=0
MEMORY_CASES=0
USER_SKIPPED_CASES=0
INTERRUPTED_CASES=0
ANOMALY_BENCHMARKS=0
SKIPPED_BENCHMARKS=0
COMPLETED_BENCHMARKS=0
FOUND_BENCHMARK_DIR=0
START_TS=$(date +%s)

finalize_summary() {
    [[ $FINALIZED -eq 1 ]] && return 0
    FINALIZED=1

    local end_ts total_cost
    end_ts=$(date +%s)
    total_cost=$((end_ts - START_TS))

    log_summary ""
    log_summary "[汇总] candidate_solver=$SOLVER"
    log_summary "[汇总] 可运行benchmark数=$DISCOVERED_BENCHMARKS"
    log_summary "[汇总] 可运行用例总数=$DISCOVERED_CASES"
    log_summary "[汇总] 实际进入benchmark数=$TOTAL_BENCHMARKS"
    log_summary "[汇总] 实际运行用例数=$TOTAL_CASES"
    log_summary "[汇总] 成功=$SUCCESS_CASES"
    log_summary "[汇总] 失败=$FAILED_CASES"
    log_summary "[汇总] 超时=$TIMEOUT_CASES"
    log_summary "[汇总] 内存限制/内存失败=$MEMORY_CASES"
    log_summary "[汇总] Ctrl+B跳过=$USER_SKIPPED_CASES"
    log_summary "[汇总] Ctrl+C中断=$INTERRUPTED_CASES"
    log_summary "[汇总] 异常benchmark=$ANOMALY_BENCHMARKS"
    log_summary "[汇总] 总耗时=${total_cost}s"
    log_summary "[汇总] 日志目录=$LOG_ROOT"
    log_summary "[汇总] 结果目录=$RESULT_ROOT"
    log_summary "[汇总] 失败清单=$FAILED_CASES_FILE"
    log_summary "[汇总] 跳过清单=$SKIPPED_CASES_FILE"
    log_summary "[汇总] 异常清单=$ANOMALIES_LOG"
}

kill_process_tree_recursive() {
    local pid="$1"
    local sig="$2"
    local child

    [[ -z "$pid" ]] && return 0
    if [[ $HAVE_PGREP -eq 1 ]]; then
        while IFS= read -r child; do
            [[ -z "$child" ]] && continue
            kill_process_tree_recursive "$child" "$sig"
        done < <(pgrep -P "$pid" 2>/dev/null || true)
    fi
    kill -"$sig" "$pid" 2>/dev/null || true
}

signal_current_case() {
    local sig="$1"
    [[ -z "$CURRENT_CHILD_PID" ]] && return 0

    if [[ -n "$CURRENT_SESSION_ID" && $HAVE_PKILL -eq 1 ]]; then
        pkill -"$sig" -s "$CURRENT_SESSION_ID" 2>/dev/null || true
    fi

    if [[ -n "$CURRENT_SESSION_ID" ]]; then
        kill -"$sig" -- "-$CURRENT_SESSION_ID" 2>/dev/null || true
    fi

    kill_process_tree_recursive "$CURRENT_CHILD_PID" "$sig"
}

terminate_current_case() {
    [[ -z "$CURRENT_CHILD_PID" ]] && return 0
    signal_current_case TERM
    sleep 1
    if kill -0 "$CURRENT_CHILD_PID" 2>/dev/null; then
        signal_current_case KILL
    fi
}

request_skip_current_case() {
    [[ -z "$CURRENT_CHILD_PID" ]] && return 0
    [[ $CURRENT_CASE_SKIP_REQUESTED -eq 1 ]] && return 0

    CURRENT_CASE_SKIP_REQUESTED=1
    echo
    echo "[快捷键] Ctrl+B：跳过当前测例 $CURRENT_BENCHMARK_NAME/$CURRENT_CASE_NAME，继续下一个。"
    [[ -n "$CURRENT_CASE_LOG_FILE" ]] \
        && echo "[用户操作] Ctrl+B：终止并跳过当前测例。" >> "$CURRENT_CASE_LOG_FILE"
    terminate_current_case
}

handle_abort_signal() {
    if [[ $ABORT_REQUESTED -eq 0 ]]; then
        ABORT_REQUESTED=1
        CURRENT_CASE_ABORT_REQUESTED=1
        echo
        echo "[中断] Ctrl+C：立即终止当前测例，并结束整个批量测试。"
        echo "[中断] 当前 benchmark=${CURRENT_BENCHMARK_NAME:-N/A} case=${CURRENT_CASE_NAME:-N/A}"
        log_summary "[中断] 收到 Ctrl+C/SIGTERM，立即终止整批测试。"
        [[ -n "$CURRENT_CASE_LOG_FILE" ]] \
            && echo "[用户操作] Ctrl+C：终止当前测例和整个批量测试。" >> "$CURRENT_CASE_LOG_FILE"
        terminate_current_case
    else
        signal_current_case KILL
    fi
}

trap 'handle_abort_signal' INT TERM
trap 'request_skip_current_case' USR1
trap 'finalize_summary' EXIT

poll_current_case() {
    local key=""

    while kill -0 "$CURRENT_CHILD_PID" 2>/dev/null; do
        if [[ $INTERACTIVE_KEYS -eq 1 ]]; then
            key=""
            if IFS= read -r -s -n 1 -t 0.20 key < /dev/tty; then
                if [[ "$key" == $'\002' ]]; then
                    request_skip_current_case
                fi
            fi
        else
            sleep 0.20
        fi

        [[ $ABORT_REQUESTED -eq 1 || $CURRENT_CASE_SKIP_REQUESTED -eq 1 ]] && sleep 0.05
    done
}

is_memory_failure_log() {
    local log_file="$1"
    grep -Eiq \
        'Cannot allocate memory|cannot allocate memory|std::bad_alloc|MemoryError|OutOfMemoryError|Java heap space|failed to allocate|cannot map memory|Killed process|out of memory' \
        "$log_file" 2>/dev/null
}

copy_legacy_result_files() {
    local marker_file="$1"
    local destination="$2"
    local source

    for source in "$ROOT_DIR/finalplan" "$ROOT_DIR/C_Plan" "$ROOT_DIR/planner.result"; do
        if [[ -f "$source" && "$source" -nt "$marker_file" ]]; then
            cp -f "$source" "$destination/$(basename "$source")" 2>/dev/null || true
        fi
    done
}

run_case() {
    local rel_bench_dir="$1"
    local domain_file="$2"
    local problem_file="$3"
    local case_name="$4"
    local pair_suffix="$5"

    local problem_basename case_log_dir case_result_dir case_log_file
    local result_file marker_file case_start case_end case_cost exit_code status
    local command_body

    CURRENT_BENCHMARK_NAME="$rel_bench_dir"
    CURRENT_CASE_NAME="$case_name"
    CURRENT_CASE_SKIP_REQUESTED=0
    CURRENT_CASE_ABORT_REQUESTED=0

    problem_basename="$(basename "$problem_file")"
    if ! matches_problem_filter "$PROBLEM_FILTER" "$case_name" "$problem_basename" "$pair_suffix"; then
        CURRENT_CASE_NAME=""
        return 0
    fi

    TOTAL_CASES=$((TOTAL_CASES + 1))

    case_log_dir="$LOG_ROOT/$rel_bench_dir"
    case_result_dir="$RESULT_ROOT/$rel_bench_dir/$case_name"
    case_log_file="$case_log_dir/$case_name.log"
    result_file="$case_result_dir/result.plan"
    marker_file="$case_result_dir/.case-start"
    CURRENT_CASE_LOG_FILE="$case_log_file"

    mkdir -p "$case_log_dir"
    rm -rf "$case_result_dir"
    mkdir -p "$case_result_dir"
    : > "$marker_file"

    case_start=$(date +%s)
    {
        echo "[开始时间] $(date '+%F %T')"
        echo "[项目根目录] $ROOT_DIR"
        echo "[候选规划器] $SOLVER"
        echo "[启动脚本] $PLAN_SCRIPT"
        echo "[benchmark] $rel_bench_dir"
        echo "[case_name] $case_name"
        [[ -n "$pair_suffix" ]] && echo "[pair_suffix] $pair_suffix"
        echo "[domain] $domain_file"
        echo "[problem] $problem_file"
        echo "[result_file] $result_file"
        echo "[display_flag] $DISPLAY_FLAG"
        echo "[timeout_sec] $TIMEOUT_SEC"
        echo "[memory_limit] $MEMORY_LIMIT"
        echo "[memory_limit_kb] $MEMORY_LIMIT_KB"
        echo "[success_marker_configured] yes"
        echo "[快捷键] Ctrl+B=跳过本例；Ctrl+C=终止整批"
        echo
    } > "$case_log_file"

    echo "[进度][用例开始] solver=$SOLVER benchmark=$rel_bench_dir case=$case_name timeout=${TIMEOUT_SEC}s memory=$MEMORY_LIMIT"

    if [[ $HAVE_SETSID -eq 1 ]]; then
        setsid bash "$CASE_RUNNER" \
            "$ROOT_DIR" "$MEMORY_LIMIT_KB" "$TIMEOUT_CMD" "$TIMEOUT_SEC" \
            "$PLAN_SCRIPT" "$domain_file" "$problem_file" "$result_file" \
            "$DISPLAY_FLAG" "$TIME_CMD" >> "$case_log_file" 2>&1 &
        CURRENT_CHILD_PID=$!
        CURRENT_SESSION_ID="$CURRENT_CHILD_PID"
    else
        bash "$CASE_RUNNER" \
            "$ROOT_DIR" "$MEMORY_LIMIT_KB" "$TIMEOUT_CMD" "$TIMEOUT_SEC" \
            "$PLAN_SCRIPT" "$domain_file" "$problem_file" "$result_file" \
            "$DISPLAY_FLAG" "$TIME_CMD" >> "$case_log_file" 2>&1 &
        CURRENT_CHILD_PID=$!
        CURRENT_SESSION_ID=""
    fi

    poll_current_case
    wait "$CURRENT_CHILD_PID"
    exit_code=$?

    CURRENT_CHILD_PID=""
    CURRENT_SESSION_ID=""

    case_end=$(date +%s)
    case_cost=$((case_end - case_start))
    copy_legacy_result_files "$marker_file" "$case_result_dir"

    status="FAIL"
    if [[ $CURRENT_CASE_ABORT_REQUESTED -eq 1 || $ABORT_REQUESTED -eq 1 ]]; then
        status="INTERRUPTED_ALL"
        INTERRUPTED_CASES=$((INTERRUPTED_CASES + 1))
        echo "$rel_bench_dir/$case_name  INTERRUPTED_ALL  log=$case_log_file" >> "$FAILED_CASES_FILE"
    elif [[ $CURRENT_CASE_SKIP_REQUESTED -eq 1 ]]; then
        status="USER_SKIP"
        USER_SKIPPED_CASES=$((USER_SKIPPED_CASES + 1))
        echo "$rel_bench_dir/$case_name  USER_SKIP  log=$case_log_file" >> "$SKIPPED_CASES_FILE"
    elif [[ $exit_code -eq 124 ]] || \
         { [[ $exit_code -eq 137 ]] && [[ $case_cost -ge $((TIMEOUT_SEC > 1 ? TIMEOUT_SEC - 1 : 1)) ]]; }; then
        status="TIMEOUT"
        FAILED_CASES=$((FAILED_CASES + 1))
        TIMEOUT_CASES=$((TIMEOUT_CASES + 1))
        echo "$rel_bench_dir/$case_name  TIMEOUT  log=$case_log_file" >> "$FAILED_CASES_FILE"
    elif [[ $exit_code -eq 137 ]] || is_memory_failure_log "$case_log_file"; then
        status="MEMORY_LIMIT_OR_OOM"
        FAILED_CASES=$((FAILED_CASES + 1))
        MEMORY_CASES=$((MEMORY_CASES + 1))
        echo "$rel_bench_dir/$case_name  MEMORY_LIMIT_OR_OOM  log=$case_log_file" >> "$FAILED_CASES_FILE"
    elif grep -Fq "$SUCCESS_MARKER" "$case_log_file"; then
        status="OK"
        SUCCESS_CASES=$((SUCCESS_CASES + 1))
    else
        status="FAIL"
        FAILED_CASES=$((FAILED_CASES + 1))
        echo "$rel_bench_dir/$case_name  EXIT_CODE=$exit_code MISSING_SUCCESS_MARKER  log=$case_log_file" >> "$FAILED_CASES_FILE"
    fi

    {
        echo
        echo "[结束时间] $(date '+%F %T')"
        echo "[耗时秒] $case_cost"
        echo "[退出码] $exit_code"
        echo "[最终状态] $status"
        if [[ "$status" == "FAIL" && $exit_code -eq 0 ]]; then
            echo "[失败原因] 进程退出码为 0，但未出现最终一致性计划接受标志。"
        fi
    } >> "$case_log_file"

    log_summary "  [$status] $rel_bench_dir/$case_name exit_code=$exit_code elapsed=${case_cost}s log=$case_log_file"
    echo "[进度][用例完成] solver=$SOLVER benchmark=$rel_bench_dir case=$case_name status=$status elapsed=${case_cost}s done=$((SUCCESS_CASES + FAILED_CASES + USER_SKIPPED_CASES + INTERRUPTED_CASES))/$DISCOVERED_CASES"

    if [[ "$status" != "OK" && "$status" != "USER_SKIP" && $CONTINUE_ON_ERROR -eq 0 ]]; then
        STOP_AFTER_CURRENT=1
    fi

    CURRENT_CASE_NAME=""
    CURRENT_CASE_LOG_FILE=""
    CURRENT_CASE_SKIP_REQUESTED=0
    CURRENT_CASE_ABORT_REQUESTED=0
    return 0
}

if [[ $BUILD_FIRST -eq 1 ]]; then
    [[ -f "$ROOT_DIR/build" ]] || fatal "--build-first 已启用，但未找到 $ROOT_DIR/build"
    echo "[构建] 执行 $ROOT_DIR/build"
    (
        cd "$ROOT_DIR" || exit 1
        bash ./build
    ) 2>&1 | tee "$LOG_ROOT/build.log"
    build_rc=${PIPESTATUS[0]}
    [[ $build_rc -eq 0 ]] || fatal "项目构建失败，退出码=$build_rc；日志：$LOG_ROOT/build.log"
fi

log_summary "[开始] ROOT_DIR=$ROOT_DIR"
log_summary "[开始] BENCH_ROOT=$BENCH_ROOT"
log_summary "[开始] candidate_solver=$SOLVER"
log_summary "[开始] PLAN_SCRIPT=$PLAN_SCRIPT"
log_summary "[开始] LOG_ROOT=$LOG_ROOT"
log_summary "[开始] RESULT_ROOT=$RESULT_ROOT"
log_summary "[开始] TIMEOUT_SEC=$TIMEOUT_SEC"
log_summary "[开始] MEMORY_LIMIT=$MEMORY_LIMIT"
log_summary "[开始] MEMORY_LIMIT_KB=$MEMORY_LIMIT_KB"
log_summary "[开始] SUCCESS_MARKER=$SUCCESS_MARKER"
log_summary "[开始] Ctrl+C=终止整批；Ctrl+B=跳过当前测例"
if [[ ${#BENCHMARK_FILTERS[@]} -gt 0 ]]; then
    log_summary "[过滤] benchmarks=${BENCHMARK_FILTERS[*]}"
fi
[[ -n "$PROBLEM_FILTER" ]] && log_summary "[过滤] problem=$PROBLEM_FILTER"
log_summary ""

# 预扫描
while IFS= read -r -d '' bench_dir; do
    FOUND_BENCHMARK_DIR=1
    bench_name="$(basename "$bench_dir")"
    benchmark_selected "$bench_name" || continue
    find "$bench_dir" -maxdepth 1 -type f -name '*.pddl' | grep -q . || continue

    selected_count="$(get_selected_case_count_for_benchmark "$bench_dir")"
    if [[ "$selected_count" =~ ^[0-9]+$ && "$selected_count" -gt 0 ]]; then
        DISCOVERED_BENCHMARKS=$((DISCOVERED_BENCHMARKS + 1))
        DISCOVERED_CASES=$((DISCOVERED_CASES + selected_count))
    fi
done < <(find "$BENCH_ROOT" -mindepth 1 -maxdepth 1 -type d -print0 | sort -zV)

[[ $FOUND_BENCHMARK_DIR -eq 1 ]] || fatal "在 $BENCH_ROOT 下没有找到 benchmark 子目录。"
[[ $DISCOVERED_CASES -gt 0 ]] || fatal "筛选后没有可运行测例。请检查 --benchmark/--problem/--case。"

log_summary "[预扫描] 可运行benchmark数=$DISCOVERED_BENCHMARKS"
log_summary "[预扫描] 可运行用例总数=$DISCOVERED_CASES"
log_summary ""

echo "[批量测试] solver=$SOLVER benchmarks=$DISCOVERED_BENCHMARKS cases=$DISCOVERED_CASES timeout=${TIMEOUT_SEC}s memory=$MEMORY_LIMIT"
if [[ $INTERACTIVE_KEYS -eq 1 ]]; then
    echo "[快捷键] Ctrl+B 跳过当前测例；Ctrl+C 立即结束整个测试。"
else
    echo "[提示] 当前没有可用交互终端；Ctrl+B 不可用，可向脚本进程发送 SIGUSR1 跳过当前测例。"
fi

while IFS= read -r -d '' BENCH_DIR; do
    [[ $ABORT_REQUESTED -eq 1 || $STOP_AFTER_CURRENT -eq 1 ]] && break

    BENCH_NAME="$(basename "$BENCH_DIR")"
    REL_BENCH_DIR="$BENCH_NAME"
    benchmark_selected "$BENCH_NAME" || continue
    find "$BENCH_DIR" -maxdepth 1 -type f -name '*.pddl' | grep -q . || continue

    SELECTED_CASES_THIS_BENCH="$(get_selected_case_count_for_benchmark "$BENCH_DIR")"
    [[ "$SELECTED_CASES_THIS_BENCH" =~ ^[0-9]+$ && "$SELECTED_CASES_THIS_BENCH" -gt 0 ]] || continue

    TOTAL_BENCHMARKS=$((TOTAL_BENCHMARKS + 1))
    BENCH_CASES_BEFORE=$TOTAL_CASES
    BENCH_SUCCESS_BEFORE=$SUCCESS_CASES
    BENCH_FAILED_BEFORE=$FAILED_CASES
    BENCH_SKIP_BEFORE=$USER_SKIPPED_CASES

    echo "[进度][基准域开始] benchmark=$REL_BENCH_DIR index=$((COMPLETED_BENCHMARKS + 1))/$DISCOVERED_BENCHMARKS"
    log_summary "[Benchmark] $REL_BENCH_DIR"

    DOMAIN_PDDL="$BENCH_DIR/domain.pddl"

    if [[ -f "$DOMAIN_PDDL" ]]; then
        mapfile -d '' PROBLEM_FILES < <(find "$BENCH_DIR" -maxdepth 1 -type f -name '*.pddl' ! -name 'domain.pddl' -print0 | sort -zV)

        if [[ ${#PROBLEM_FILES[@]} -eq 0 ]]; then
            log_anomaly "  [异常] $REL_BENCH_DIR：存在 domain.pddl，但没有 problem 文件"
            ANOMALY_BENCHMARKS=$((ANOMALY_BENCHMARKS + 1))
            SKIPPED_BENCHMARKS=$((SKIPPED_BENCHMARKS + 1))
            continue
        fi

        for PROBLEM_FILE in "${PROBLEM_FILES[@]}"; do
            PROBLEM_BASENAME="$(basename "$PROBLEM_FILE")"
            CASE_NAME="${PROBLEM_BASENAME%.pddl}"
            run_case "$REL_BENCH_DIR" "$DOMAIN_PDDL" "$PROBLEM_FILE" "$CASE_NAME" ""
            [[ $ABORT_REQUESTED -eq 1 || $STOP_AFTER_CURRENT -eq 1 ]] && break
        done
    else
        mapfile -d '' D_FILES < <(find "$BENCH_DIR" -maxdepth 1 -type f -name 'd*.pddl' -print0 | sort -zV)
        mapfile -d '' P_FILES < <(find "$BENCH_DIR" -maxdepth 1 -type f -name 'p*.pddl' -print0 | sort -zV)

        if [[ ${#D_FILES[@]} -eq 0 || ${#P_FILES[@]} -eq 0 ]]; then
            log_anomaly "  [异常] $REL_BENCH_DIR：没有 domain.pddl，也无法形成 d*/p* 配对"
            ANOMALY_BENCHMARKS=$((ANOMALY_BENCHMARKS + 1))
            SKIPPED_BENCHMARKS=$((SKIPPED_BENCHMARKS + 1))
            continue
        fi

        declare -A D_MAP=()
        declare -A P_MAP=()

        for D_FILE in "${D_FILES[@]}"; do
            D_BASE="$(basename "$D_FILE")"
            D_KEY="${D_BASE#d}"
            D_KEY="${D_KEY%.pddl}"
            D_MAP["$D_KEY"]="$D_FILE"
        done

        for P_FILE in "${P_FILES[@]}"; do
            P_BASE="$(basename "$P_FILE")"
            P_KEY="${P_BASE#p}"
            P_KEY="${P_KEY%.pddl}"
            P_MAP["$P_KEY"]="$P_FILE"
        done

        mapfile -t D_KEYS_SORTED < <(printf '%s\n' "${!D_MAP[@]}" | sort -V)
        mapfile -t P_KEYS_SORTED < <(printf '%s\n' "${!P_MAP[@]}" | sort -V)

        MISSING_PAIR_COUNT=0
        PAIR_COUNT=0

        for KEY in "${D_KEYS_SORTED[@]}"; do
            if [[ -n "${P_MAP[$KEY]:-}" ]]; then
                PAIR_COUNT=$((PAIR_COUNT + 1))
                run_case "$REL_BENCH_DIR" "${D_MAP[$KEY]}" "${P_MAP[$KEY]}" "p$KEY" "$KEY"
                [[ $ABORT_REQUESTED -eq 1 || $STOP_AFTER_CURRENT -eq 1 ]] && break
            else
                MISSING_PAIR_COUNT=$((MISSING_PAIR_COUNT + 1))
                log_anomaly "  [异常] $REL_BENCH_DIR：缺少与 d$KEY.pddl 对应的 p$KEY.pddl"
            fi
        done

        if [[ $ABORT_REQUESTED -eq 0 && $STOP_AFTER_CURRENT -eq 0 ]]; then
            for KEY in "${P_KEYS_SORTED[@]}"; do
                if [[ -z "${D_MAP[$KEY]:-}" ]]; then
                    MISSING_PAIR_COUNT=$((MISSING_PAIR_COUNT + 1))
                    log_anomaly "  [异常] $REL_BENCH_DIR：缺少与 p$KEY.pddl 对应的 d$KEY.pddl"
                fi
            done
        fi

        [[ $MISSING_PAIR_COUNT -gt 0 ]] && ANOMALY_BENCHMARKS=$((ANOMALY_BENCHMARKS + 1))
        if [[ $PAIR_COUNT -eq 0 ]]; then
            SKIPPED_BENCHMARKS=$((SKIPPED_BENCHMARKS + 1))
        fi

        unset D_MAP P_MAP
    fi

    COMPLETED_BENCHMARKS=$((COMPLETED_BENCHMARKS + 1))
    echo "[进度][基准域完成] benchmark=$REL_BENCH_DIR index=$COMPLETED_BENCHMARKS/$DISCOVERED_BENCHMARKS cases=$((TOTAL_CASES - BENCH_CASES_BEFORE)) success=$((SUCCESS_CASES - BENCH_SUCCESS_BEFORE)) failed=$((FAILED_CASES - BENCH_FAILED_BEFORE)) skipped=$((USER_SKIPPED_CASES - BENCH_SKIP_BEFORE))"
    log_summary ""
done < <(find "$BENCH_ROOT" -mindepth 1 -maxdepth 1 -type d -print0 | sort -zV)

finalize_summary

if [[ $ABORT_REQUESTED -eq 1 ]]; then
    echo "批量测试已由 Ctrl+C 中止。汇总：$SUMMARY_LOG"
    exit 130
fi

if [[ $STOP_AFTER_CURRENT -eq 1 ]]; then
    echo "批量测试因 --stop-on-error 停止。汇总：$SUMMARY_LOG"
    exit 2
fi

if [[ $FAILED_CASES -gt 0 ]]; then
    echo "批量测试完成：存在失败、超时或内存失败用例。汇总：$SUMMARY_LOG"
    exit 2
fi

if [[ $USER_SKIPPED_CASES -gt 0 ]]; then
    echo "批量测试完成：无失败，但有 Ctrl+B 跳过用例。汇总：$SUMMARY_LOG"
    exit 3
fi

echo "批量测试完成：全部成功。汇总：$SUMMARY_LOG"
exit 0
