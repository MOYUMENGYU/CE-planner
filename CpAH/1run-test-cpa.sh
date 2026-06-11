#!/usr/bin/env bash
# CPA(H) 批量自动测试脚本（参考 run-test-pip-fixed.sh 改造版）
#
# 适用目录：
#   CPA(H) 解压目录，目录中应包含：CPAH、run_cpah.sh、cpa.pddl2pl
#
# 支持两类测试用例：
#   1) PDDL：
#      - domain.pddl + problem*.pddl
#      - d*.pddl + p*.pddl
#      - d*.pddl + p*.pddl~
#      - 单文件 PDDL：*.pddl / *.pddl~（没有 domain.pddl、也不是 d/p 配对时）
#      执行方式：
#        若是 domain/problem 分离，先合并为 case-input.pddl，再执行：
#          cd <cpa_dir> && ./run_cpah.sh <case-input.pddl>
#        若本来就是单文件 PDDL，直接执行：
#          cd <cpa_dir> && ./run_cpah.sh <case.pddl>
#
#   2) AL：
#      - *.al
#      执行：cd <cpa_dir> && ./CPAH <case.al> > plan-result
#
# 关键保证：
#   - 所有 domain/problem/al 路径在执行前转成绝对路径，避免 cd cpa_dir 后相对路径失效
#   - CPA(H) 原始 run_cpah.sh 实际只使用第一个参数，所以分离式 PDDL 会先合并再运行
#   - 每个用例执行前清理 plan-result、theory_names、theory_*.al、temp 等中间文件
#   - 每个用例执行后立即保存 plan-result，避免下一用例覆盖
#   - 控制台输出完整保存到每个用例独立日志
#   - 不使用宽泛的 "ERROR:" 判断失败，避免误判
#   - 支持 timeout、内存限制、benchmark/problem 过滤、Ctrl+C 优雅退出
#
# 示例：
#   ./run-test-cpa-fixed.sh -t ./CPA-Benchmark-succes
#   ./run-test-cpa-fixed.sh -t ./CPA-Benchmark-succes -b blocks
#   ./run-test-cpa-fixed.sh -t ./CPA-Benchmark-succes -b blocks -p b2
#   ./run-test-cpa-fixed.sh -t ./benchmarks --mode al
#   ./run-test-cpa-fixed.sh -t ./CPA-Benchmark-succes --timeout 3600 --mem-gb 16

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR"
CPA_DIR=""
CPA_BIN=""
TEST_ROOT=""
LOG_ROOT_BASE=""
RESULT_ROOT_BASE=""

MODE="auto"     # auto / pddl / al / both
TIMEOUT_SEC=3600
MEM_LIMIT_GB=16
MEM_LIMIT_KB=$((MEM_LIMIT_GB * 1024 * 1024))
BENCHMARK_FILTER=""
PROBLEM_FILTER=""
RUN_ID="$(date +%Y%m%d_%H%M%S)"
CONTINUE_ON_ERROR=1

usage() {
    cat <<USAGE
用法：
  $(basename "$0") [选项]

选项：
  --root DIR               项目根目录，默认：脚本所在目录
  --cpa-dir DIR            CPA(H) 工作目录，默认：
                           优先使用当前工作目录；若当前目录含 ./CPAH 和 ./run_cpah.sh，则为当前目录
  --cpa-bin FILE           CPA(H) 可执行文件，默认：<cpa_dir>/CPAH
  -t, --test-root DIR      测试根目录，默认：<root>/Benchmark
  -l, --log-root DIR       日志根目录，默认：<cpa_dir>/cpa_test_logs
  -r, --result-root DIR    结果根目录，默认：<cpa_dir>/cpa_result_output_batch
  -b, --benchmark NAME     只运行指定 benchmark 目录名，例如 blocks
  -p, --problem NAME       只运行指定 case，例如 b2 / p2-5 / p2-5.pddl / ring-new2
  --mode MODE              测试模式：auto / pddl / al / both，默认：auto
                           auto：有 PDDL 就跑 PDDL；没有 PDDL 但有 AL 就跑 AL
                           both：PDDL 和 AL 都跑
  --run-id ID              指定本轮运行 ID
  --timeout SEC            单用例超时秒数，默认：3600
  --mem-gb GB              单用例内存限制 GB，默认：16
  --stop-on-error          遇到失败立即停止
  -h, --help               显示帮助

输出：
  控制台日志：<log_root>/<run_id>/<benchmark>/<case>.log
  CPA结果文件：<result_root>/<run_id>/<benchmark>/<case>/plan-result
  汇总日志：  <log_root>/<run_id>/summary.log
  失败清单：  <log_root>/<run_id>/failed_cases.txt
  异常清单：  <log_root>/<run_id>/anomalies.log

示例：
  ./run-test-cpa-fixed.sh -t ./CPA-Benchmark-succes
  ./run-test-cpa-fixed.sh -t ./CPA-Benchmark-succes -b blocks
  ./run-test-cpa-fixed.sh -t ./CPA-Benchmark-succes -b blocks -p b2
  ./run-test-cpa-fixed.sh -t ./benchmarks --mode al
  ./run-test-cpa-fixed.sh -t ./CPA-Benchmark-succes --timeout 3600 --mem-gb 16
USAGE
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --root)
            ROOT_DIR="$2"
            shift 2
            ;;
        --cpa-dir)
            CPA_DIR="$2"
            shift 2
            ;;
        --cpa-bin)
            CPA_BIN="$2"
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
        -b|--benchmark)
            BENCHMARK_FILTER="$2"
            shift 2
            ;;
        -p|--problem)
            PROBLEM_FILTER="$2"
            shift 2
            ;;
        --mode)
            MODE="$2"
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

if [[ -z "$CPA_DIR" ]]; then
    # 优先使用“当前工作目录”。这样从 CpAH 解压目录执行时，默认就是当前目录，
    # 其中 ./CPAH 是可执行文件，而不是子目录。
    if [[ -x "$PWD/CPAH" && -f "$PWD/run_cpah.sh" ]]; then
        CPA_DIR="$PWD"
    elif [[ -x "$ROOT_DIR/CPAH" && -f "$ROOT_DIR/run_cpah.sh" ]]; then
        CPA_DIR="$ROOT_DIR"
    elif [[ -d "$PWD/CPAH" ]]; then
        CPA_DIR="$PWD/CPAH"
    else
        CPA_DIR="$ROOT_DIR/CPAH"
    fi
fi

CPA_DIR="$(abs_path_existing_dir "$CPA_DIR")"
if [[ -z "$CPA_DIR" || ! -d "$CPA_DIR" ]]; then
    echo "[错误] 未找到 CPA(H) 工作目录。" >&2
    echo "[提示] 如果当前目录中有 CPAH 可执行文件和 run_cpah.sh，请使用 --cpa-dir ." >&2
    echo "[提示] 当前目录：$PWD" >&2
    echo "[提示] 脚本目录：$SCRIPT_DIR" >&2
    exit 1
fi

[[ -z "$CPA_BIN" ]] && CPA_BIN="$CPA_DIR/CPAH"
if [[ -f "$CPA_BIN" ]]; then
    CPA_BIN="$(abs_path_existing_file "$CPA_BIN")"
fi

[[ -z "$TEST_ROOT" ]] && TEST_ROOT="$ROOT_DIR/Benchmark"
[[ -z "$LOG_ROOT_BASE" ]] && LOG_ROOT_BASE="$CPA_DIR/cpa_test_logs"
[[ -z "$RESULT_ROOT_BASE" ]] && RESULT_ROOT_BASE="$CPA_DIR/cpa_result_output_batch"

if [[ ! -x "$CPA_BIN" ]]; then
    echo "[错误] 未找到可执行的 CPAH：$CPA_BIN" >&2
    echo "[提示] 请确认 CPAH 已存在并 chmod +x，或用 --cpa-bin 指定路径。" >&2
    exit 1
fi

if [[ ! -x "$CPA_DIR/run_cpah.sh" ]]; then
    echo "[警告] 未找到可执行的 run_cpah.sh：$CPA_DIR/run_cpah.sh"
    echo "[警告] PDDL 模式会失败；AL 模式不受影响。"
fi

if [[ ! -x "$CPA_DIR/cpa.pddl2pl" ]]; then
    echo "[警告] 未找到可执行的 cpa.pddl2pl：$CPA_DIR/cpa.pddl2pl"
    echo "[警告] PDDL 模式可能失败；AL 模式不受影响。"
fi

if [[ ! -d "$TEST_ROOT" ]]; then
    echo "[错误] 未找到测试目录：$TEST_ROOT" >&2
    exit 1
fi
TEST_ROOT="$(abs_path_existing_dir "$TEST_ROOT")"

case "$MODE" in
    auto|pddl|al|both) ;;
    *)
        echo "[错误] --mode 只能是 auto / pddl / al / both。" >&2
        exit 1
        ;;
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
    x="${x%.al}"
    echo "$x"
}

matches_problem_filter() {
    local filter="$1"
    local case_name="$2"
    local file_base="$3"
    local pair_suffix="$4"
    local f

    if [[ -z "$filter" ]]; then
        return 0
    fi

    f="$(strip_case_ext "$filter")"

    if [[ "$case_name" == "$filter" || "$case_name" == "$f" ]]; then
        return 0
    fi

    if [[ "$file_base" == "$filter" || "$(strip_case_ext "$file_base")" == "$f" ]]; then
        return 0
    fi

    if [[ -n "$pair_suffix" && ( "$pair_suffix" == "$filter" || "$pair_suffix" == "$f" ) ]]; then
        return 0
    fi

    return 1
}

cleanup_cpa_workdir() {
    rm -f "$CPA_DIR"/dp.pddl \
          "$CPA_DIR"/case-input.pddl \
          "$CPA_DIR"/pddl2pl.pl \
          "$CPA_DIR"/new.pl \
          "$CPA_DIR"/theory_names \
          "$CPA_DIR"/theory_*.al \
          "$CPA_DIR"/temp \
          "$CPA_DIR"/plan-result \
          "$CPA_DIR"/result-time \
          "$CPA_DIR"/trash 2>/dev/null || true
}

save_outputs() {
    local case_result_dir="$1"
    local case_log_file="$2"
    local f

    mkdir -p "$case_result_dir"

    for f in plan-result result-time temp trash dp.pddl case-input.pddl pddl2pl.pl new.pl theory_names; do
        if [[ -f "$CPA_DIR/$f" ]]; then
            cp -f "$CPA_DIR/$f" "$case_result_dir/$f"
            echo "[保存] $f -> $case_result_dir/$f" >> "$case_log_file"
        fi
    done

    shopt -s nullglob
    for f in "$CPA_DIR"/theory_*.al; do
        cp -f "$f" "$case_result_dir/$(basename "$f")"
        echo "[保存] $(basename "$f") -> $case_result_dir/$(basename "$f")" >> "$case_log_file"
    done
    shopt -u nullglob

    [[ -f "$case_result_dir/plan-result" ]]
}

detect_fatal_pddl_error() {
    local log_file="$1"

    # 注意：不要匹配泛化的 ERROR:，否则可能把非致命输出误判为转换失败。
    grep -Eiq \
        "syntax error at symbol|scanner input buffer overflow|input in flex scanner failed|cpa\.pddl2pl.*(No such file|not found|cannot execute|Exec format error|Permission denied)|sicstus: command not found|SICStus.*license|swipl: command not found|prolog: command not found|run_cpah\.sh.*(No such file|Permission denied)|sic_script\.sh.*(No such file|Permission denied)|swi_script\.sh.*(No such file|Permission denied)|mult5zz\.pl.*No such file|pddl2pl\.pl.*No such file|theory_names.*No such file|cannot execute binary file|Segmentation fault|core dumped" \
        "$log_file"
}

classify_result() {
    local type="$1"
    local rc="$2"
    local plan_file="$3"
    local log_file="$4"

    if [[ "$rc" -eq 124 || "$rc" -eq 137 ]]; then
        echo "TIMEOUT"
        return 0
    fi

    if [[ "$type" == "PDDL" ]] && detect_fatal_pddl_error "$log_file"; then
        echo "PDDL_TRANSLATE_OR_SCRIPT_ERROR"
        return 0
    fi

    if [[ ! -f "$plan_file" ]]; then
        echo "NO_PLAN_RESULT"
        return 0
    fi

    if [[ ! -s "$plan_file" ]]; then
        echo "EMPTY_PLAN_RESULT"
        return 0
    fi

    if grep -Eiq "No plan was found|No plan|No solution|unsolvable|goal.*not.*reachable|failed" "$plan_file"; then
        echo "NO_PLAN_OR_FAILED"
        return 0
    fi

    # CPA(H) 找到计划时通常直接打印动作序列和统计信息，不一定包含固定的 Found a plan 字样。
    # 因此：退出码为 0、plan-result 非空、且没有 No plan/fatal 标记时，按成功保存。
    if [[ "$rc" -eq 0 ]]; then
        echo "FOUND_PLAN"
        return 0
    fi

    echo "EXIT_CODE_${rc}"
}

FINALIZED=0
INTERRUPT_COUNT=0
CURRENT_CHILD_PID=""
CURRENT_CASE_NAME=""
CURRENT_BENCHMARK_NAME=""
CURRENT_CASE_LOG_FILE=""

DISCOVERED_BENCHMARKS=0
DISCOVERED_CASES=0
TOTAL_BENCHMARKS=0
COMPLETED_BENCHMARKS=0
TOTAL_CASES=0
SUCCESS_CASES=0
FAILED_CASES=0
TIMEOUT_CASES=0
TRANSLATE_ERROR_CASES=0
MISSING_RESULT_CASES=0
SKIPPED_BENCHMARKS=0
ANOMALY_BENCHMARKS=0
STOP_REQUESTED=0
STOP_REQUESTED_EXIT_CODE=0
START_TS=$(date +%s)
FOUND_BENCHMARK_DIR=0
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
        log_summary "[中止] 已收到中断/停止请求。"
    fi

    log_summary "[汇总] 可运行benchmark数=$DISCOVERED_BENCHMARKS"
    log_summary "[汇总] 可运行用例总数=$DISCOVERED_CASES"
    log_summary "[汇总] 实际进入benchmark数=$TOTAL_BENCHMARKS"
    log_summary "[汇总] 实际运行用例数=$TOTAL_CASES"
    log_summary "[汇总] 成功=$SUCCESS_CASES"
    log_summary "[汇总] 失败=$FAILED_CASES"
    log_summary "[汇总] 其中超时=$TIMEOUT_CASES"
    log_summary "[汇总] PDDL转换/脚本错误=$TRANSLATE_ERROR_CASES"
    log_summary "[汇总] plan-result缺失=$MISSING_RESULT_CASES"
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
        echo "[中断] 将在当前用例结束后退出。再次按 Ctrl+C 可立即终止。"
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

inc_status_count() {
    local status="$1"

    case "$status" in
        FOUND_PLAN)
            SUCCESS_CASES=$((SUCCESS_CASES + 1))
            ;;
        TIMEOUT)
            FAILED_CASES=$((FAILED_CASES + 1))
            TIMEOUT_CASES=$((TIMEOUT_CASES + 1))
            ;;
        PDDL_TRANSLATE_OR_SCRIPT_ERROR)
            FAILED_CASES=$((FAILED_CASES + 1))
            TRANSLATE_ERROR_CASES=$((TRANSLATE_ERROR_CASES + 1))
            ;;
        NO_PLAN_RESULT)
            FAILED_CASES=$((FAILED_CASES + 1))
            MISSING_RESULT_CASES=$((MISSING_RESULT_CASES + 1))
            ;;
        *)
            FAILED_CASES=$((FAILED_CASES + 1))
            ;;
    esac
}

is_success_status() {
    [[ "$1" == "FOUND_PLAN" ]]
}

record_case_result() {
    local rel_bench_dir="$1"
    local case_name="$2"
    local type="$3"
    local status="$4"
    local rc="$5"
    local elapsed="$6"
    local result_status="$7"
    local log_file="$8"

    inc_status_count "$status"

    if is_success_status "$status"; then
        log_summary "  [完成] $rel_bench_dir / $case_name type=$type status=$status exit_code=$rc elapsed=${elapsed}s result=$result_status log=$log_file"
        echo "[进度] solver=CPAH benchmark=$rel_bench_dir case=$case_name type=$type status=$status elapsed=${elapsed}s success=$SUCCESS_CASES failed=$FAILED_CASES total=$TOTAL_CASES/$DISCOVERED_CASES"
    else
        echo "$rel_bench_dir/$case_name  $status  type=$type exit_code=$rc result=$result_status log=$log_file" >> "$FAILED_CASES_FILE"
        echo "[失败原因] $status" >> "$log_file"
        log_summary "  [失败] $rel_bench_dir / $case_name type=$type status=$status exit_code=$rc elapsed=${elapsed}s result=$result_status log=$log_file"
        echo "[进度] solver=CPAH benchmark=$rel_bench_dir case=$case_name type=$type status=$status elapsed=${elapsed}s success=$SUCCESS_CASES failed=$FAILED_CASES total=$TOTAL_CASES/$DISCOVERED_CASES"

        if [[ $CONTINUE_ON_ERROR -eq 0 ]]; then
            STOP_REQUESTED=1
            STOP_REQUESTED_EXIT_CODE=1
        fi
    fi
}

prepare_combined_pddl() {
    local domain_file="$1"
    local problem_file="$2"
    local output_file="$3"

    if [[ -n "$domain_file" && -n "$problem_file" ]]; then
        cat "$domain_file" "$problem_file" > "$output_file"
    else
        cp -f "$problem_file" "$output_file"
    fi
}

run_pddl_case() {
    local rel_bench_dir="$1"
    local domain_file="$2"
    local problem_file="$3"
    local case_name="$4"
    local pair_suffix="$5"

    local problem_base domain_abs problem_abs case_log_dir case_result_dir case_log_file case_input_file
    local start_ts end_ts elapsed rc result_saved status

    problem_base="$(basename "$problem_file")"
    if ! matches_problem_filter "$PROBLEM_FILTER" "$case_name" "$problem_base" "$pair_suffix"; then
        return 0
    fi

    if [[ -n "$domain_file" ]]; then
        domain_abs="$(abs_path_existing_file "$domain_file")"
    else
        domain_abs=""
    fi
    problem_abs="$(abs_path_existing_file "$problem_file")"

    if [[ -z "$problem_abs" || ( -n "$domain_file" && -z "$domain_abs" ) ]]; then
        log_anomaly "  [异常] $rel_bench_dir/$case_name ：domain/problem 路径无法解析"
        ANOMALY_BENCHMARKS=$((ANOMALY_BENCHMARKS + 1))
        return 0
    fi

    TOTAL_CASES=$((TOTAL_CASES + 1))
    CURRENT_BENCHMARK_NAME="$rel_bench_dir"
    CURRENT_CASE_NAME="$case_name"

    case_log_dir="$LOG_ROOT/$rel_bench_dir"
    case_result_dir="$RESULT_ROOT/$rel_bench_dir/$case_name"
    case_log_file="$case_log_dir/$case_name.log"
    case_input_file="$case_result_dir/case-input.pddl"
    CURRENT_CASE_LOG_FILE="$case_log_file"

    mkdir -p "$case_log_dir"
    rm -rf "$case_result_dir"
    mkdir -p "$case_result_dir"

    prepare_combined_pddl "$domain_abs" "$problem_abs" "$case_input_file"

    cleanup_cpa_workdir

    start_ts=$(date +%s)
    {
        echo "[开始时间] $(date '+%F %T')"
        echo "[求解器] CPAH"
        echo "[类型] PDDL"
        echo "[ROOT_DIR] $ROOT_DIR"
        echo "[CPA_DIR] $CPA_DIR"
        echo "[CPA_BIN] $CPA_BIN"
        echo "[benchmark] $rel_bench_dir"
        echo "[case_name] $case_name"
        [[ -n "$pair_suffix" ]] && echo "[pair_suffix] $pair_suffix"
        [[ -n "$domain_abs" ]] && echo "[domain] $domain_abs"
        echo "[problem] $problem_abs"
        echo "[case_input_pddl] $case_input_file"
        echo "[result_dir] $case_result_dir"
        echo "[timeout_sec] $TIMEOUT_SEC"
        echo "[mem_limit_gb] $MEM_LIMIT_GB"
        echo "[mem_limit_kb_ulimit_v] $MEM_LIMIT_KB"
        echo "[command] cd $CPA_DIR && ./run_cpah.sh $case_input_file"
        echo
    } > "$case_log_file"

    (
        trap '' INT
        cd "$CPA_DIR" || exit 1
        cleanup_cpa_workdir
        cp -f "$case_input_file" "$CPA_DIR/case-input.pddl" 2>/dev/null || true
        cp -f "$case_input_file" "$CPA_DIR/dp.pddl" 2>/dev/null || true
        ulimit -v "$MEM_LIMIT_KB" 2>/dev/null || true
        exec "$TIMEOUT_CMD" --signal=TERM --kill-after=10s "$TIMEOUT_SEC" \
            ./run_cpah.sh "$case_input_file"
    ) >> "$case_log_file" 2>&1 &
    CURRENT_CHILD_PID=$!

    wait_for_current_child
    rc=$?
    CURRENT_CHILD_PID=""

    end_ts=$(date +%s)
    elapsed=$((end_ts - start_ts))

    {
        echo
        echo "[结束时间] $(date '+%F %T')"
        echo "[耗时秒] $elapsed"
        echo "[退出码] $rc"
    } >> "$case_log_file"

    if save_outputs "$case_result_dir" "$case_log_file"; then
        result_saved="RESULT_SAVED"
    else
        result_saved="NO_PLAN_RESULT"
    fi

    status="$(classify_result "PDDL" "$rc" "$case_result_dir/plan-result" "$case_log_file")"
    record_case_result "$rel_bench_dir" "$case_name" "PDDL" "$status" "$rc" "$elapsed" "$result_saved" "$case_log_file"

    CURRENT_CASE_NAME=""
    CURRENT_CASE_LOG_FILE=""
    return 0
}

run_al_case() {
    local rel_bench_dir="$1"
    local al_file="$2"
    local case_name="$3"

    local al_base al_abs case_log_dir case_result_dir case_log_file
    local start_ts end_ts elapsed rc result_saved status

    al_base="$(basename "$al_file")"
    if ! matches_problem_filter "$PROBLEM_FILTER" "$case_name" "$al_base" ""; then
        return 0
    fi

    al_abs="$(abs_path_existing_file "$al_file")"
    if [[ -z "$al_abs" ]]; then
        log_anomaly "  [异常] $rel_bench_dir/$case_name ：AL 路径无法解析"
        ANOMALY_BENCHMARKS=$((ANOMALY_BENCHMARKS + 1))
        return 0
    fi

    TOTAL_CASES=$((TOTAL_CASES + 1))
    CURRENT_BENCHMARK_NAME="$rel_bench_dir"
    CURRENT_CASE_NAME="$case_name"

    case_log_dir="$LOG_ROOT/$rel_bench_dir"
    case_result_dir="$RESULT_ROOT/$rel_bench_dir/$case_name"
    case_log_file="$case_log_dir/$case_name.log"
    CURRENT_CASE_LOG_FILE="$case_log_file"

    mkdir -p "$case_log_dir"
    rm -rf "$case_result_dir"
    mkdir -p "$case_result_dir"

    cleanup_cpa_workdir

    start_ts=$(date +%s)
    {
        echo "[开始时间] $(date '+%F %T')"
        echo "[求解器] CPAH"
        echo "[类型] AL"
        echo "[ROOT_DIR] $ROOT_DIR"
        echo "[CPA_DIR] $CPA_DIR"
        echo "[CPA_BIN] $CPA_BIN"
        echo "[benchmark] $rel_bench_dir"
        echo "[case_name] $case_name"
        echo "[al_file] $al_abs"
        echo "[result_dir] $case_result_dir"
        echo "[timeout_sec] $TIMEOUT_SEC"
        echo "[mem_limit_gb] $MEM_LIMIT_GB"
        echo "[mem_limit_kb_ulimit_v] $MEM_LIMIT_KB"
        echo "[command] cd $CPA_DIR && $CPA_BIN $al_abs > plan-result"
        echo
    } > "$case_log_file"

    (
        trap '' INT
        cd "$CPA_DIR" || exit 1
        cleanup_cpa_workdir
        ulimit -v "$MEM_LIMIT_KB" 2>/dev/null || true
        "$TIMEOUT_CMD" --signal=TERM --kill-after=10s "$TIMEOUT_SEC" \
            "$CPA_BIN" "$al_abs" > plan-result
    ) >> "$case_log_file" 2>&1 &
    CURRENT_CHILD_PID=$!

    wait_for_current_child
    rc=$?
    CURRENT_CHILD_PID=""

    end_ts=$(date +%s)
    elapsed=$((end_ts - start_ts))

    {
        echo
        echo "[结束时间] $(date '+%F %T')"
        echo "[耗时秒] $elapsed"
        echo "[退出码] $rc"
    } >> "$case_log_file"

    if save_outputs "$case_result_dir" "$case_log_file"; then
        result_saved="RESULT_SAVED"
    else
        result_saved="NO_PLAN_RESULT"
    fi

    status="$(classify_result "AL" "$rc" "$case_result_dir/plan-result" "$case_log_file")"
    record_case_result "$rel_bench_dir" "$case_name" "AL" "$status" "$rc" "$elapsed" "$result_saved" "$case_log_file"

    CURRENT_CASE_NAME=""
    CURRENT_CASE_LOG_FILE=""
    return 0
}

count_pddl_cases_for_benchmark() {
    local bench_dir="$1"
    local domain_pddl problem_file problem_base case_name
    local d_file p_file d_base p_base key d_key p_key
    local count=0

    domain_pddl="$bench_dir/domain.pddl"

    if [[ -f "$domain_pddl" ]]; then
        while IFS= read -r -d '' problem_file; do
            problem_base="$(basename "$problem_file")"
            case_name="$(strip_case_ext "$problem_base")"
            if matches_problem_filter "$PROBLEM_FILTER" "$case_name" "$problem_base" ""; then
                count=$((count + 1))
            fi
        done < <(find "$bench_dir" -maxdepth 1 -type f \( -name '*.pddl' -o -name '*.pddl~' \) ! -name 'domain.pddl' -print0 | sort -z -V)
    else
        declare -A d_map=()
        declare -A p_map=()

        while IFS= read -r -d '' d_file; do
            d_base="$(basename "$d_file")"
            d_key="${d_base#d}"
            d_key="${d_key%.pddl~}"
            d_key="${d_key%.pddl}"
            d_map["$d_key"]="$d_file"
        done < <(find "$bench_dir" -maxdepth 1 -type f \( -name 'd*.pddl' -o -name 'd*.pddl~' \) -print0 | sort -z -V)

        while IFS= read -r -d '' p_file; do
            p_base="$(basename "$p_file")"
            p_key="${p_base#p}"
            p_key="${p_key%.pddl~}"
            p_key="${p_key%.pddl}"
            p_map["$p_key"]="$p_file"
        done < <(find "$bench_dir" -maxdepth 1 -type f \( -name 'p*.pddl' -o -name 'p*.pddl~' \) -print0 | sort -z -V)

        if [[ ${#d_map[@]} -gt 0 ]]; then
            while IFS= read -r key; do
                [[ -z "$key" ]] && continue
                if [[ -n "${p_map[$key]:-}" ]]; then
                    problem_base="$(basename "${p_map[$key]}")"
                    case_name="p$key"
                    if matches_problem_filter "$PROBLEM_FILTER" "$case_name" "$problem_base" "$key"; then
                        count=$((count + 1))
                    fi
                fi
            done < <(printf '%s\n' "${!d_map[@]}" | sort -V)
        else
            # 没有 domain.pddl，也没有 d/p 配对时，按单文件 PDDL 处理。
            while IFS= read -r -d '' problem_file; do
                problem_base="$(basename "$problem_file")"
                case_name="$(strip_case_ext "$problem_base")"
                if matches_problem_filter "$PROBLEM_FILTER" "$case_name" "$problem_base" ""; then
                    count=$((count + 1))
                fi
            done < <(find "$bench_dir" -maxdepth 1 -type f \( -name '*.pddl' -o -name '*.pddl~' \) -print0 | sort -z -V)
        fi
    fi

    echo "$count"
}

count_al_cases_for_benchmark() {
    local bench_dir="$1"
    local al_file al_base case_name count=0

    while IFS= read -r -d '' al_file; do
        al_base="$(basename "$al_file")"
        case_name="${al_base%.al}"
        if matches_problem_filter "$PROBLEM_FILTER" "$case_name" "$al_base" ""; then
            count=$((count + 1))
        fi
    done < <(find "$bench_dir" -maxdepth 1 -type f -name '*.al' -print0 | sort -z -V)

    echo "$count"
}

selected_counts_for_benchmark() {
    local bench_dir="$1"
    local pddl_count al_count selected_pddl selected_al
    pddl_count="$(count_pddl_cases_for_benchmark "$bench_dir")"
    al_count="$(count_al_cases_for_benchmark "$bench_dir")"

    selected_pddl=0
    selected_al=0

    case "$MODE" in
        pddl)
            selected_pddl="$pddl_count"
            ;;
        al)
            selected_al="$al_count"
            ;;
        both)
            selected_pddl="$pddl_count"
            selected_al="$al_count"
            ;;
        auto)
            if [[ "$pddl_count" -gt 0 ]]; then
                selected_pddl="$pddl_count"
            elif [[ "$al_count" -gt 0 ]]; then
                selected_al="$al_count"
            fi
            ;;
    esac

    echo "$selected_pddl $selected_al"
}

run_pddl_cases_for_benchmark() {
    local bench_dir="$1"
    local rel_bench_dir="$2"
    local domain_pddl problem_file problem_base case_name
    local d_file p_file d_base p_base key d_key p_key

    domain_pddl="$bench_dir/domain.pddl"

    if [[ -f "$domain_pddl" ]]; then
        while IFS= read -r -d '' problem_file; do
            problem_base="$(basename "$problem_file")"
            case_name="$(strip_case_ext "$problem_base")"
            run_pddl_case "$rel_bench_dir" "$domain_pddl" "$problem_file" "$case_name" ""
            [[ $STOP_REQUESTED -eq 1 ]] && break
        done < <(find "$bench_dir" -maxdepth 1 -type f \( -name '*.pddl' -o -name '*.pddl~' \) ! -name 'domain.pddl' -print0 | sort -z -V)
    else
        declare -A d_map=()
        declare -A p_map=()

        while IFS= read -r -d '' d_file; do
            d_base="$(basename "$d_file")"
            d_key="${d_base#d}"
            d_key="${d_key%.pddl~}"
            d_key="${d_key%.pddl}"
            d_map["$d_key"]="$d_file"
        done < <(find "$bench_dir" -maxdepth 1 -type f \( -name 'd*.pddl' -o -name 'd*.pddl~' \) -print0 | sort -z -V)

        while IFS= read -r -d '' p_file; do
            p_base="$(basename "$p_file")"
            p_key="${p_base#p}"
            p_key="${p_key%.pddl~}"
            p_key="${p_key%.pddl}"
            p_map["$p_key"]="$p_file"
        done < <(find "$bench_dir" -maxdepth 1 -type f \( -name 'p*.pddl' -o -name 'p*.pddl~' \) -print0 | sort -z -V)

        if [[ ${#d_map[@]} -gt 0 ]]; then
            if [[ ${#p_map[@]} -eq 0 ]]; then
                log_anomaly "  [异常] $rel_bench_dir ：没有 domain.pddl，且 d*.pddl/p*.pddl 配对不完整"
                ANOMALY_BENCHMARKS=$((ANOMALY_BENCHMARKS + 1))
            fi

            while IFS= read -r key; do
                [[ -z "$key" ]] && continue

                if [[ -z "${p_map[$key]:-}" ]]; then
                    log_anomaly "  [异常] $rel_bench_dir ：存在 d$key.pddl，但缺少 p$key.pddl 或 p$key.pddl~"
                    ANOMALY_BENCHMARKS=$((ANOMALY_BENCHMARKS + 1))
                    continue
                fi

                run_pddl_case "$rel_bench_dir" "${d_map[$key]}" "${p_map[$key]}" "p$key" "$key"
                [[ $STOP_REQUESTED -eq 1 ]] && break
            done < <(printf '%s\n' "${!d_map[@]}" | sort -V)
        else
            # 没有 domain.pddl，也没有 d/p 配对时，按单文件 PDDL 处理。
            while IFS= read -r -d '' problem_file; do
                problem_base="$(basename "$problem_file")"
                case_name="$(strip_case_ext "$problem_base")"
                run_pddl_case "$rel_bench_dir" "" "$problem_file" "$case_name" ""
                [[ $STOP_REQUESTED -eq 1 ]] && break
            done < <(find "$bench_dir" -maxdepth 1 -type f \( -name '*.pddl' -o -name '*.pddl~' \) -print0 | sort -z -V)
        fi
    fi
}

run_al_cases_for_benchmark() {
    local bench_dir="$1"
    local rel_bench_dir="$2"
    local al_file al_base case_name

    while IFS= read -r -d '' al_file; do
        al_base="$(basename "$al_file")"
        case_name="${al_base%.al}"
        run_al_case "$rel_bench_dir" "$al_file" "$case_name"
        [[ $STOP_REQUESTED -eq 1 ]] && break
    done < <(find "$bench_dir" -maxdepth 1 -type f -name '*.al' -print0 | sort -z -V)
}

log_summary "[开始] ROOT_DIR=$ROOT_DIR"
log_summary "[开始] TEST_ROOT=$TEST_ROOT"
log_summary "[开始] CPA_DIR=$CPA_DIR"
log_summary "[开始] CPA_BIN=$CPA_BIN"
log_summary "[开始] MODE=$MODE"
log_summary "[开始] LOG_ROOT=$LOG_ROOT"
log_summary "[开始] RESULT_ROOT=$RESULT_ROOT"
log_summary "[开始] TIMEOUT_SEC=$TIMEOUT_SEC"
log_summary "[开始] MEM_LIMIT_GB=$MEM_LIMIT_GB"
log_summary "[开始] MEM_LIMIT_KB=$MEM_LIMIT_KB"
log_summary "[开始] HAVE_PGREP=$HAVE_PGREP"
[[ -n "$BENCHMARK_FILTER" ]] && log_summary "[过滤] benchmark=$BENCHMARK_FILTER"
[[ -n "$PROBLEM_FILTER" ]] && log_summary "[过滤] problem=$PROBLEM_FILTER"
log_summary ""

# 预扫描
while IFS= read -r -d '' bench_dir; do
    FOUND_BENCHMARK_DIR=1
    bench_name="$(basename "$bench_dir")"

    if [[ -n "$BENCHMARK_FILTER" && "$bench_name" != "$BENCHMARK_FILTER" ]]; then
        continue
    fi

    read -r pddl_count al_count < <(selected_counts_for_benchmark "$bench_dir")
    selected_count=$((pddl_count + al_count))

    if [[ "$selected_count" -gt 0 ]]; then
        DISCOVERED_BENCHMARKS=$((DISCOVERED_BENCHMARKS + 1))
        DISCOVERED_CASES=$((DISCOVERED_CASES + selected_count))
    fi
done < <(find "$TEST_ROOT" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z -V)

log_summary "[预扫描] 可运行benchmark数=$DISCOVERED_BENCHMARKS"
log_summary "[预扫描] 可运行用例总数=$DISCOVERED_CASES"
log_summary ""

echo "[开始] solver=CPAH run_id=$RUN_ID mode=$MODE timeout=${TIMEOUT_SEC}s mem=${MEM_LIMIT_GB}GB"
echo "[开始] test_root=$TEST_ROOT"
echo "[开始] cpa_dir=$CPA_DIR"
echo "[开始] benchmark_count=$DISCOVERED_BENCHMARKS case_count=$DISCOVERED_CASES"

# 正式运行
while IFS= read -r -d '' bench_dir; do
    FOUND_BENCHMARK_DIR=1
    bench_name="$(basename "$bench_dir")"
    rel_bench_dir="$bench_name"

    if [[ -n "$BENCHMARK_FILTER" && "$bench_name" != "$BENCHMARK_FILTER" ]]; then
        continue
    fi

    read -r selected_pddl selected_al < <(selected_counts_for_benchmark "$bench_dir")
    selected_total=$((selected_pddl + selected_al))

    if [[ "$selected_total" -le 0 ]]; then
        continue
    fi

    TOTAL_BENCHMARKS=$((TOTAL_BENCHMARKS + 1))
    echo "[基准域开始] $rel_bench_dir pddl=$selected_pddl al=$selected_al"
    log_summary "[Benchmark] $rel_bench_dir pddl=$selected_pddl al=$selected_al"

    before_cases="$TOTAL_CASES"
    before_success="$SUCCESS_CASES"
    before_failed="$FAILED_CASES"

    if [[ "$selected_pddl" -gt 0 ]]; then
        run_pddl_cases_for_benchmark "$bench_dir" "$rel_bench_dir"
    fi

    if [[ $STOP_REQUESTED -eq 0 && "$selected_al" -gt 0 ]]; then
        run_al_cases_for_benchmark "$bench_dir" "$rel_bench_dir"
    fi

    COMPLETED_BENCHMARKS=$((COMPLETED_BENCHMARKS + 1))
    bench_cases=$((TOTAL_CASES - before_cases))
    bench_success=$((SUCCESS_CASES - before_success))
    bench_failed=$((FAILED_CASES - before_failed))

    log_summary "[Benchmark完成] $rel_bench_dir cases=$bench_cases success=$bench_success failed=$bench_failed"
    log_summary ""
    echo "[基准域完成] $rel_bench_dir cases=$bench_cases success=$bench_success failed=$bench_failed"

    if [[ $STOP_REQUESTED -eq 1 ]]; then
        break
    fi
done < <(find "$TEST_ROOT" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z -V)

if [[ $FOUND_BENCHMARK_DIR -eq 0 ]]; then
    echo "[错误] 测试根目录下没有 benchmark 子目录：$TEST_ROOT" >&2
    log_anomaly "[错误] 测试根目录下没有 benchmark 子目录：$TEST_ROOT"
fi

finalize_summary

echo "[完成] total=$TOTAL_CASES success=$SUCCESS_CASES failed=$FAILED_CASES elapsed=$(($(date +%s) - START_TS))s"
echo "[完成] summary=$SUMMARY_LOG"
echo "[完成] result_root=$RESULT_ROOT"

if [[ $STOP_REQUESTED -eq 1 ]]; then
    exit "$STOP_REQUESTED_EXIT_CODE"
fi

if [[ $FAILED_CASES -gt 0 ]]; then
    exit 1
fi

exit 0
