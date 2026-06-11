#!/usr/bin/env bash
# iGC 批量自动测试脚本（优雅退出正式版）
# 兼容当前 test 中两类命名：
# 1) 共享 domain 型： benchmark/domain.pddl + 其他 *.pddl
# 2) d/p 成对型：     benchmark/d*.pddl 与 benchmark/p*.pddl 一一配对
#
# 改进点：
# - 默认不依赖绝对路径，以脚本所在目录为项目根目录
# - 每个测试用例独立日志文件与独立结果目录
# - planner 输出不打印到控制台，只写入日志文件
# - 单用例默认超时 15 分钟
# - 预扫描可运行 benchmark / case 总数，进度提示更准确
# - 支持 Ctrl+C 优雅退出：第一次请求“当前用例结束后退出”，第二次立即终止
# - 将异常 benchmark / 缺失配对情况写入汇总日志

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR"
PLAN_SCRIPT=""
DEFAULT_TIMEOUT_SEC=300
DISPLAY_FLAG="false"
BENCHMARK_FILTER=""
PROBLEM_FILTER=""
CONTINUE_ON_ERROR=1
RUN_ID="$(date +%Y%m%d_%H%M%S)"
TIMEOUT_SEC="$DEFAULT_TIMEOUT_SEC"
TEST_ROOT=""
LOG_ROOT_BASE=""
RESULT_ROOT_BASE=""

usage() {
    cat <<USAGE
用法：
  $(basename "$0") [选项]

选项：
  --root DIR               项目根目录，默认：脚本所在目录
  -t, --test-root DIR      测试根目录，默认：<root>/test
  -l, --log-root DIR       日志根目录，默认：<root>/test_logs
  -r, --result-root DIR    结果根目录，默认：<root>/result_output_batch
  -d, --display FLAG       传给 ./plan 的第 4 个参数，默认：false
  -b, --benchmark NAME     只运行指定 benchmark（目录名）
  -p, --problem NAME       只运行指定 problem，可写成：
                           b4 / b4.pddl / p2-2 / p2-2.pddl / 2-2
  --run-id ID              指定本轮运行 ID
  --timeout SEC            单用例超时秒数，默认：900（15分钟）
  --stop-on-error          遇到失败立即停止
  -h, --help               显示帮助

说明：
  1. 建议将脚本放在项目根目录，与 plan 同级。
  2. 每个用例日志写入：<log_root>/<run_id>/<benchmark>/<case>.log
  3. 每轮批次汇总写入：<log_root>/<run_id>/summary.log
  4. 失败用例清单写入：<log_root>/<run_id>/failed_cases.txt
  5. 异常 benchmark 清单写入：<log_root>/<run_id>/anomalies.log
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
        -d|--display)
            DISPLAY_FLAG="$2"
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

ROOT_DIR="$(cd "$ROOT_DIR" 2>/dev/null && pwd)"
if [[ -z "$ROOT_DIR" ]]; then
    echo "[错误] 无法解析项目根目录。" >&2
    exit 1
fi

PLAN_SCRIPT="$ROOT_DIR/plan"
[[ -z "$TEST_ROOT" ]] && TEST_ROOT="$ROOT_DIR/test"
[[ -z "$LOG_ROOT_BASE" ]] && LOG_ROOT_BASE="$ROOT_DIR/test_logs"
[[ -z "$RESULT_ROOT_BASE" ]] && RESULT_ROOT_BASE="$ROOT_DIR/result_output_batch"

if [[ ! -f "$PLAN_SCRIPT" ]]; then
    echo "[错误] 未找到 plan 脚本：$PLAN_SCRIPT" >&2
    exit 1
fi

if [[ ! -d "$TEST_ROOT" ]]; then
    echo "[错误] 未找到 test 目录：$TEST_ROOT" >&2
    exit 1
fi

if [[ ! "$TIMEOUT_SEC" =~ ^[0-9]+$ ]] || [[ "$TIMEOUT_SEC" -le 0 ]]; then
    echo "[错误] --timeout 必须是正整数秒数。" >&2
    exit 1
fi

mkdir -p "$LOG_ROOT_BASE" "$RESULT_ROOT_BASE"
TEST_ROOT="$(cd "$TEST_ROOT" 2>/dev/null && pwd)"
LOG_ROOT_BASE="$(cd "$LOG_ROOT_BASE" 2>/dev/null && pwd)"
RESULT_ROOT_BASE="$(cd "$RESULT_ROOT_BASE" 2>/dev/null && pwd)"

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
    echo "[错误] 当前机器没有可用的 timeout/gtimeout 命令，无法执行超时控制。" >&2
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

matches_problem_filter() {
    local filter="$1"
    local case_name="$2"
    local problem_base="$3"
    local pair_suffix="$4"

    if [[ -z "$filter" ]]; then
        return 0
    fi

    local f_noext="$filter"
    if [[ "$f_noext" == *.pddl ]]; then
        f_noext="${f_noext%.pddl}"
    fi

    if [[ "$problem_base" == "$filter" || "$case_name" == "$filter" || "$case_name" == "$f_noext" ]]; then
        return 0
    fi

    if [[ -n "$pair_suffix" && ( "$pair_suffix" == "$filter" || "$pair_suffix" == "$f_noext" ) ]]; then
        return 0
    fi

    return 1
}

get_selected_case_count_for_benchmark() {
    local bench_dir="$1"
    local bench_name count
    local domain_pddl problem_file problem_basename case_name
    local d_file p_file d_base p_base d_key p_key key
    count=0
    bench_name="$(basename "$bench_dir")"

    if [[ -n "$BENCHMARK_FILTER" && "$bench_name" != "$BENCHMARK_FILTER" ]]; then
        echo 0
        return 0
    fi

    domain_pddl="$bench_dir/domain.pddl"
    if [[ -f "$domain_pddl" ]]; then
        while IFS= read -r -d '' problem_file; do
            problem_basename="$(basename "$problem_file")"
            case_name="${problem_basename%.pddl}"
            if matches_problem_filter "$PROBLEM_FILTER" "$case_name" "$problem_basename" ""; then
                count=$((count + 1))
            fi
        done < <(find "$bench_dir" -maxdepth 1 -type f -name '*.pddl' ! -name 'domain.pddl' -print0 | sort -z)
    else
        declare -A d_map=()
        declare -A p_map=()
        while IFS= read -r -d '' d_file; do
            d_base="$(basename "$d_file")"
            d_key="${d_base#d}"
            d_key="${d_key%.pddl}"
            d_map["$d_key"]="$d_file"
        done < <(find "$bench_dir" -maxdepth 1 -type f -name 'd*.pddl' -print0 | sort -z)
        while IFS= read -r -d '' p_file; do
            p_base="$(basename "$p_file")"
            p_key="${p_base#p}"
            p_key="${p_key%.pddl}"
            p_map["$p_key"]="$p_file"
        done < <(find "$bench_dir" -maxdepth 1 -type f -name 'p*.pddl' -print0 | sort -z)
        while IFS= read -r key; do
            [[ -z "$key" ]] && continue
            if [[ -n "${p_map[$key]:-}" ]]; then
                problem_basename="$(basename "${p_map[$key]}")"
                case_name="p$key"
                if matches_problem_filter "$PROBLEM_FILTER" "$case_name" "$problem_basename" "$key"; then
                    count=$((count + 1))
                fi
            fi
        done < <(printf '%s\n' "${!d_map[@]}" | sort)
    fi

    echo "$count"
}

FINALIZED=0
INTERRUPT_COUNT=0
CURRENT_CASE_NAME=""
CURRENT_BENCHMARK_NAME=""
CURRENT_CASE_LOG_FILE=""
CURRENT_CHILD_PID=""

TOTAL_BENCHMARKS=0
TOTAL_CASES=0
SUCCESS_CASES=0
FAILED_CASES=0
TIMEOUT_CASES=0
SKIPPED_BENCHMARKS=0
ANOMALY_BENCHMARKS=0
STOP_REQUESTED=0
STOP_REQUESTED_EXIT_CODE=0
START_TS=$(date +%s)
FOUND_BENCHMARK_DIR=0
DISCOVERED_BENCHMARKS=0
DISCOVERED_CASES=0
COMPLETED_BENCHMARKS=0
IMMEDIATE_INTERRUPT_RECORDED=0

finalize_summary() {
    if [[ $FINALIZED -eq 1 ]]; then
        return 0
    fi
    FINALIZED=1

    local end_ts total_cost
    end_ts=$(date +%s)
    total_cost=$((end_ts - START_TS))

    if [[ $STOP_REQUESTED -eq 1 ]]; then
        log_summary "[中止] 已收到中断请求；在当前用例结束后退出。"
    fi

    log_summary "[汇总] 可运行benchmark数=$DISCOVERED_BENCHMARKS"
    log_summary "[汇总] 可运行用例总数=$DISCOVERED_CASES"
    log_summary "[汇总] 实际进入benchmark数=$TOTAL_BENCHMARKS"
    log_summary "[汇总] 实际运行用例数=$TOTAL_CASES"
    log_summary "[汇总] 成功=$SUCCESS_CASES"
    log_summary "[汇总] 失败=$FAILED_CASES"
    log_summary "[汇总] 其中超时=$TIMEOUT_CASES"
    log_summary "[汇总] 跳过benchmark=$SKIPPED_BENCHMARKS"
    log_summary "[汇总] 异常benchmark=$ANOMALY_BENCHMARKS"
    log_summary "[汇总] 总耗时=${total_cost}s"
    log_summary "[汇总] 日志目录=$LOG_ROOT"
    log_summary "[汇总] 结果目录=$RESULT_ROOT"
    log_summary "[汇总] 失败清单=$FAILED_CASES_FILE"
    log_summary "[汇总] 异常清单=$ANOMALIES_LOG"
}

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
    if [[ -z "$CURRENT_CHILD_PID" ]]; then
        return 0
    fi

    kill_process_tree "$CURRENT_CHILD_PID" TERM
    sleep 1
    kill_process_tree "$CURRENT_CHILD_PID" KILL
}

handle_interrupt() {
    INTERRUPT_COUNT=$((INTERRUPT_COUNT + 1))

    if [[ $INTERRUPT_COUNT -eq 1 ]]; then
        STOP_REQUESTED=1
        STOP_REQUESTED_EXIT_CODE=130

        echo
        echo "[中断] 已收到中断信号。"
        echo "[中断] 当前 benchmark=${CURRENT_BENCHMARK_NAME:-N/A} case=${CURRENT_CASE_NAME:-N/A}"
        echo "[中断] 将在当前用例结束后优雅退出。再次按 Ctrl+C 可立即终止。"

        log_summary "[中断] 收到 SIGINT/SIGTERM，准备在当前用例结束后退出。"
        log_summary "[中断] 当前 benchmark=${CURRENT_BENCHMARK_NAME:-N/A} case=${CURRENT_CASE_NAME:-N/A}"
    else
        echo
        echo "[中断] 第二次收到中断信号，立即终止当前用例并退出。"
        log_summary "[中断] 第二次收到 SIGINT/SIGTERM，立即终止当前用例并退出。"
        if [[ -n "$CURRENT_CASE_LOG_FILE" ]]; then
            echo "[用户中断] 第二次 Ctrl+C，立即终止当前用例。" >> "$CURRENT_CASE_LOG_FILE"
        fi
        if [[ -n "$CURRENT_CASE_NAME" && $IMMEDIATE_INTERRUPT_RECORDED -eq 0 ]]; then
            FAILED_CASES=$((FAILED_CASES + 1))
            echo "$CURRENT_BENCHMARK_NAME/$CURRENT_CASE_NAME  INTERRUPTED_FORCE  log=$CURRENT_CASE_LOG_FILE" >> "$FAILED_CASES_FILE"
            IMMEDIATE_INTERRUPT_RECORDED=1
        fi
        terminate_current_child_now
        finalize_summary
        exit 130
    fi
}

trap 'handle_interrupt' INT TERM

wait_for_current_child() {
    local wait_rc
    while true; do
        wait "$CURRENT_CHILD_PID"
        wait_rc=$?
        if [[ $wait_rc -eq 0 ]]; then
            return 0
        fi
        if kill -0 "$CURRENT_CHILD_PID" 2>/dev/null; then
            sleep 1
            continue
        fi
        return "$wait_rc"
    done
}

run_case() {
    local rel_bench_dir="$1"
    local domain_file="$2"
    local problem_file="$3"
    local case_name="$4"
    local pair_suffix="$5"

    local problem_basename case_log_dir case_result_dir case_log_file
    local case_start case_end case_cost exit_code

    CURRENT_BENCHMARK_NAME="$rel_bench_dir"
    CURRENT_CASE_NAME="$case_name"

    problem_basename="$(basename "$problem_file")"

    if ! matches_problem_filter "$PROBLEM_FILTER" "$case_name" "$problem_basename" "$pair_suffix"; then
        CURRENT_CASE_NAME=""
        return 0
    fi

    TOTAL_CASES=$((TOTAL_CASES + 1))

    case_log_dir="$LOG_ROOT/$rel_bench_dir"
    case_result_dir="$RESULT_ROOT/$rel_bench_dir/$case_name"
    case_log_file="$case_log_dir/$case_name.log"
    CURRENT_CASE_LOG_FILE="$case_log_file"

    mkdir -p "$case_log_dir"
    rm -rf "$case_result_dir"
    mkdir -p "$case_result_dir"

    case_start=$(date +%s)
    {
        echo "[开始时间] $(date '+%F %T')"
        echo "[项目根目录] $ROOT_DIR"
        echo "[benchmark] $rel_bench_dir"
        echo "[case_name] $case_name"
        [[ -n "$pair_suffix" ]] && echo "[pair_suffix] $pair_suffix"
        echo "[domain] $domain_file"
        echo "[problem] $problem_file"
        echo "[result_dir] $case_result_dir"
        echo "[display_flag] $DISPLAY_FLAG"
        echo "[timeout_sec] $TIMEOUT_SEC"
        echo "[interrupt_mode] child_ignore_SIGINT"
        echo
    } > "$case_log_file"

    (
        trap '' INT
        cd "$ROOT_DIR" || exit 1
        exec "$TIMEOUT_CMD" --signal=TERM --kill-after=10s "$TIMEOUT_SEC" \
            bash "$PLAN_SCRIPT" "$domain_file" "$problem_file" "$case_result_dir" "$DISPLAY_FLAG"
    ) >> "$case_log_file" 2>&1 &
    CURRENT_CHILD_PID=$!

    wait_for_current_child
    exit_code=$?

    CURRENT_CHILD_PID=""

    case_end=$(date +%s)
    case_cost=$((case_end - case_start))

    {
        echo
        echo "[结束时间] $(date '+%F %T')"
        echo "[耗时秒] $case_cost"
        echo "[退出码] $exit_code"
    } >> "$case_log_file"

    if [[ $exit_code -eq 0 ]]; then
        SUCCESS_CASES=$((SUCCESS_CASES + 1))
        log_summary "  [完成] $rel_bench_dir / $case_name  exit_code=0 elapsed=${case_cost}s  log=$case_log_file"
        echo "[进度][用例完成] benchmark=$rel_bench_dir case=$case_name status=OK elapsed=${case_cost}s total_done=$((SUCCESS_CASES + FAILED_CASES))/$DISCOVERED_CASES"
    elif [[ $exit_code -eq 124 || $exit_code -eq 137 ]]; then
        FAILED_CASES=$((FAILED_CASES + 1))
        TIMEOUT_CASES=$((TIMEOUT_CASES + 1))
        echo "$rel_bench_dir/$case_name  TIMEOUT  log=$case_log_file" >> "$FAILED_CASES_FILE"
        echo "[失败原因] TIMEOUT" >> "$case_log_file"
        log_summary "  [超时] $rel_bench_dir / $case_name  exit_code=$exit_code elapsed=${case_cost}s  log=$case_log_file"
        echo "[进度][用例完成] benchmark=$rel_bench_dir case=$case_name status=TIMEOUT elapsed=${case_cost}s total_done=$((SUCCESS_CASES + FAILED_CASES))/$DISCOVERED_CASES"
        if [[ $CONTINUE_ON_ERROR -eq 0 ]]; then
            STOP_REQUESTED_EXIT_CODE=$exit_code
            STOP_REQUESTED=1
        fi
    elif [[ $exit_code -eq 130 && $STOP_REQUESTED -eq 1 ]]; then
        FAILED_CASES=$((FAILED_CASES + 1))
        echo "$rel_bench_dir/$case_name  INTERRUPTED  log=$case_log_file" >> "$FAILED_CASES_FILE"
        echo "[失败原因] INTERRUPTED" >> "$case_log_file"
        log_summary "  [中断] $rel_bench_dir / $case_name  exit_code=$exit_code elapsed=${case_cost}s  log=$case_log_file"
        echo "[进度][用例完成] benchmark=$rel_bench_dir case=$case_name status=INTERRUPTED elapsed=${case_cost}s total_done=$((SUCCESS_CASES + FAILED_CASES))/$DISCOVERED_CASES"
    else
        FAILED_CASES=$((FAILED_CASES + 1))
        echo "$rel_bench_dir/$case_name  EXIT_CODE=$exit_code  log=$case_log_file" >> "$FAILED_CASES_FILE"
        log_summary "  [失败] $rel_bench_dir / $case_name  exit_code=$exit_code elapsed=${case_cost}s  log=$case_log_file"
        echo "[进度][用例完成] benchmark=$rel_bench_dir case=$case_name status=FAIL exit_code=$exit_code elapsed=${case_cost}s total_done=$((SUCCESS_CASES + FAILED_CASES))/$DISCOVERED_CASES"
        if [[ $CONTINUE_ON_ERROR -eq 0 ]]; then
            STOP_REQUESTED_EXIT_CODE=$exit_code
            STOP_REQUESTED=1
        fi
    fi

    CURRENT_CASE_NAME=""
    CURRENT_CASE_LOG_FILE=""
    return 0
}

log_summary "[开始] ROOT_DIR=$ROOT_DIR"
log_summary "[开始] TEST_ROOT=$TEST_ROOT"
log_summary "[开始] LOG_ROOT=$LOG_ROOT"
log_summary "[开始] RESULT_ROOT=$RESULT_ROOT"
log_summary "[开始] DISPLAY_FLAG=$DISPLAY_FLAG"
log_summary "[开始] TIMEOUT_SEC=$TIMEOUT_SEC"
log_summary "[开始] HAVE_PGREP=$HAVE_PGREP"
[[ -n "$BENCHMARK_FILTER" ]] && log_summary "[过滤] benchmark=$BENCHMARK_FILTER"
[[ -n "$PROBLEM_FILTER" ]] && log_summary "[过滤] problem=$PROBLEM_FILTER"
log_summary ""

while IFS= read -r -d '' bench_dir; do
    FOUND_BENCHMARK_DIR=1
    if ! find "$bench_dir" -maxdepth 1 -type f -name '*.pddl' | grep -q .; then
        continue
    fi
    selected_count="$(get_selected_case_count_for_benchmark "$bench_dir")"
    if [[ "$selected_count" =~ ^[0-9]+$ ]] && [[ "$selected_count" -gt 0 ]]; then
        DISCOVERED_BENCHMARKS=$((DISCOVERED_BENCHMARKS + 1))
        DISCOVERED_CASES=$((DISCOVERED_CASES + selected_count))
    fi
done < <(find "$TEST_ROOT" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

log_summary "[预扫描] 可运行benchmark数=$DISCOVERED_BENCHMARKS"
log_summary "[预扫描] 可运行用例总数=$DISCOVERED_CASES"
log_summary ""

while IFS= read -r -d '' BENCH_DIR; do
    FOUND_BENCHMARK_DIR=1

    BENCH_NAME="$(basename "$BENCH_DIR")"
    REL_BENCH_DIR="$BENCH_NAME"

    if [[ -n "$BENCHMARK_FILTER" && "$BENCH_NAME" != "$BENCHMARK_FILTER" ]]; then
        continue
    fi

    if ! find "$BENCH_DIR" -maxdepth 1 -type f -name '*.pddl' | grep -q .; then
        continue
    fi

    SELECTED_CASES_THIS_BENCH="$(get_selected_case_count_for_benchmark "$BENCH_DIR")"
    if [[ ! "$SELECTED_CASES_THIS_BENCH" =~ ^[0-9]+$ ]] || [[ "$SELECTED_CASES_THIS_BENCH" -le 0 ]]; then
        if [[ -n "$PROBLEM_FILTER" ]]; then
            continue
        fi
    fi

    BENCH_CASES_BEFORE="$TOTAL_CASES"
    BENCH_SUCCESS_BEFORE="$SUCCESS_CASES"
    BENCH_FAILED_BEFORE="$FAILED_CASES"

    DOMAIN_PDDL="$BENCH_DIR/domain.pddl"
    BENCH_HAS_RUNNABLE_CASE=0

    if [[ -f "$DOMAIN_PDDL" ]]; then
        mapfile -d '' PROBLEM_FILES < <(find "$BENCH_DIR" -maxdepth 1 -type f -name '*.pddl' ! -name 'domain.pddl' -print0 | sort -z)

        if [[ ${#PROBLEM_FILES[@]} -eq 0 ]]; then
            log_anomaly "  [异常] $REL_BENCH_DIR ：存在 domain.pddl，但没有任何 problem 文件"
            SKIPPED_BENCHMARKS=$((SKIPPED_BENCHMARKS + 1))
            ANOMALY_BENCHMARKS=$((ANOMALY_BENCHMARKS + 1))
            log_summary ""
            continue
        fi

        if [[ "$SELECTED_CASES_THIS_BENCH" =~ ^[0-9]+$ ]] && [[ "$SELECTED_CASES_THIS_BENCH" -gt 0 ]]; then
            TOTAL_BENCHMARKS=$((TOTAL_BENCHMARKS + 1))
            echo "[进度][基准域开始] benchmark=$REL_BENCH_DIR index=$((COMPLETED_BENCHMARKS + 1))/$DISCOVERED_BENCHMARKS"
            log_summary "[Benchmark] $REL_BENCH_DIR"
        fi

        for PROBLEM_FILE in "${PROBLEM_FILES[@]}"; do
            PROBLEM_BASENAME="$(basename "$PROBLEM_FILE")"
            CASE_NAME="${PROBLEM_BASENAME%.pddl}"
            if matches_problem_filter "$PROBLEM_FILTER" "$CASE_NAME" "$PROBLEM_BASENAME" ""; then
                BENCH_HAS_RUNNABLE_CASE=1
            fi
            run_case "$REL_BENCH_DIR" "$DOMAIN_PDDL" "$PROBLEM_FILE" "$CASE_NAME" ""
            if [[ $STOP_REQUESTED -eq 1 ]]; then
                break
            fi
        done
    else
        mapfile -d '' D_FILES < <(find "$BENCH_DIR" -maxdepth 1 -type f -name 'd*.pddl' -print0 | sort -z)
        mapfile -d '' P_FILES < <(find "$BENCH_DIR" -maxdepth 1 -type f -name 'p*.pddl' -print0 | sort -z)

        if [[ ${#D_FILES[@]} -eq 0 || ${#P_FILES[@]} -eq 0 ]]; then
            log_anomaly "  [异常] $REL_BENCH_DIR ：既没有 domain.pddl，也无法形成 d*/p* 配对"
            SKIPPED_BENCHMARKS=$((SKIPPED_BENCHMARKS + 1))
            ANOMALY_BENCHMARKS=$((ANOMALY_BENCHMARKS + 1))
            log_summary ""
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

        mapfile -t D_KEYS_SORTED < <(printf '%s\n' "${!D_MAP[@]}" | sort)
        mapfile -t P_KEYS_SORTED < <(printf '%s\n' "${!P_MAP[@]}" | sort)

        if [[ "$SELECTED_CASES_THIS_BENCH" =~ ^[0-9]+$ ]] && [[ "$SELECTED_CASES_THIS_BENCH" -gt 0 ]]; then
            TOTAL_BENCHMARKS=$((TOTAL_BENCHMARKS + 1))
            echo "[进度][基准域开始] benchmark=$REL_BENCH_DIR index=$((COMPLETED_BENCHMARKS + 1))/$DISCOVERED_BENCHMARKS"
            log_summary "[Benchmark] $REL_BENCH_DIR"
        fi

        PAIR_COUNT=0
        MISSING_PAIR_COUNT=0

        for KEY in "${D_KEYS_SORTED[@]}"; do
            if [[ -n "${P_MAP[$KEY]:-}" ]]; then
                PAIR_COUNT=$((PAIR_COUNT + 1))
                DOMAIN_FILE="${D_MAP[$KEY]}"
                PROBLEM_FILE="${P_MAP[$KEY]}"
                CASE_NAME="p$KEY"
                if matches_problem_filter "$PROBLEM_FILTER" "$CASE_NAME" "$(basename "$PROBLEM_FILE")" "$KEY"; then
                    BENCH_HAS_RUNNABLE_CASE=1
                fi
                run_case "$REL_BENCH_DIR" "$DOMAIN_FILE" "$PROBLEM_FILE" "$CASE_NAME" "$KEY"
                if [[ $STOP_REQUESTED -eq 1 ]]; then
                    break
                fi
            else
                MISSING_PAIR_COUNT=$((MISSING_PAIR_COUNT + 1))
                log_anomaly "  [异常] $REL_BENCH_DIR ：缺少与 d$KEY.pddl 对应的 p$KEY.pddl"
            fi
        done

        if [[ $STOP_REQUESTED -ne 1 ]]; then
            for KEY in "${P_KEYS_SORTED[@]}"; do
                if [[ -z "${D_MAP[$KEY]:-}" ]]; then
                    MISSING_PAIR_COUNT=$((MISSING_PAIR_COUNT + 1))
                    log_anomaly "  [异常] $REL_BENCH_DIR ：缺少与 p$KEY.pddl 对应的 d$KEY.pddl"
                fi
            done
        fi

        if [[ $PAIR_COUNT -eq 0 ]]; then
            SKIPPED_BENCHMARKS=$((SKIPPED_BENCHMARKS + 1))
            ANOMALY_BENCHMARKS=$((ANOMALY_BENCHMARKS + 1))
        elif [[ $MISSING_PAIR_COUNT -gt 0 ]]; then
            ANOMALY_BENCHMARKS=$((ANOMALY_BENCHMARKS + 1))
        fi
    fi

    if [[ $BENCH_HAS_RUNNABLE_CASE -eq 1 ]]; then
        BENCH_CASES_RUN=$((TOTAL_CASES - BENCH_CASES_BEFORE))
        BENCH_SUCCESS_RUN=$((SUCCESS_CASES - BENCH_SUCCESS_BEFORE))
        BENCH_FAILED_RUN=$((FAILED_CASES - BENCH_FAILED_BEFORE))
        COMPLETED_BENCHMARKS=$((COMPLETED_BENCHMARKS + 1))
        echo "[进度][基准域完成] benchmark=$REL_BENCH_DIR index=$COMPLETED_BENCHMARKS/$DISCOVERED_BENCHMARKS cases=$BENCH_CASES_RUN success=$BENCH_SUCCESS_RUN failed=$BENCH_FAILED_RUN"
        log_summary ""
    fi

    if [[ $STOP_REQUESTED -eq 1 ]]; then
        break
    fi
done < <(find "$TEST_ROOT" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

if [[ $FOUND_BENCHMARK_DIR -eq 0 ]]; then
    echo "[错误] 在 $TEST_ROOT 下没有找到任何 benchmark 子目录。" >&2
    exit 1
fi

finalize_summary

if [[ $STOP_REQUESTED -eq 1 ]]; then
    echo "批量测试已中止。汇总见：$SUMMARY_LOG"
    exit "${STOP_REQUESTED_EXIT_CODE:-130}"
fi

if [[ $FAILED_CASES -gt 0 ]]; then
    echo "批量测试完成：存在失败/超时用例。汇总见：$SUMMARY_LOG"
    exit 2
fi

echo "批量测试完成：全部成功。汇总见：$SUMMARY_LOG"
exit 0
