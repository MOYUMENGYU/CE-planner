#!/usr/bin/env bash
# DNF 批量自动测试脚本（修正版：避免 ERROR: 误判）
#
# 适配 Conformant_AIJ-DNF/dnf_planner。
#
# 支持两类输入：
#   1. PDDL：domain.pddl + problem.pddl，或 d*.pddl + p*.pddl 成对文件
#      执行方式：cd <dnf_planner> && ./run_cpah.sh <domain> <problem>
#      每次测试后保存 plan-result / result-time / theory_*.al / temp / trash 等文件。
#
#   2. AL：*.al 文件，domain/problem 已经合一
#      执行方式：cd <dnf_planner> && ./dnf <case.al>
#      直接把 DNF 输出保存为该用例的 plan-result。
#
# 默认：
#   timeout = 3600 秒
#   memory  = 16GB
#
# 输出：
#   日志：<log-root>/<run-id>/<benchmark>/<case>.log
#   结果：<result-root>/<run-id>/<benchmark>/<case>/plan-result

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR"

TEST_ROOT=""
DNF_PLANNER_DIR=""
DNF_BIN=""
RUN_CPAH=""

LOG_ROOT_BASE=""
RESULT_ROOT_BASE=""
RUN_ID="$(date +%Y%m%d_%H%M%S)"

TIMEOUT_SEC=3600
MEM_GB=16
MODE="auto"        # auto | pddl | al
BENCHMARK_FILTER=""
PROBLEM_FILTER=""
STOP_ON_ERROR=0

usage() {
cat <<USAGE
用法：
  $(basename "$0") [选项]

常用选项：
  --root DIR              根目录，默认：脚本所在目录
  -t, --test-root DIR     benchmark 根目录，例如 ./DNF-Benchmark-succes 或 ./benchmarks
  --dnf-dir DIR           dnf_planner 目录，默认自动识别
  --dnf-bin FILE          DNF 可执行文件，默认 <dnf-dir>/dnf
  --run-cpah FILE         PDDL 测试脚本，默认 <dnf-dir>/run_cpah.sh
  --mode auto|pddl|al     测试模式，默认 auto
  -b, --benchmark NAME    只测试某个 benchmark 目录
  -p, --problem NAME      只测试某个 case，例如 p2-5 / p2-5.pddl / 2-5 / theory_0
  --timeout SEC           单用例超时秒数，默认 3600
  --mem-gb GB             单用例内存限制 GB，默认 16
  -l, --log-root DIR      日志根目录，默认 <root>/dnf_test_logs
  -r, --result-root DIR   结果根目录，默认 <root>/dnf_result_output_batch
  --run-id ID             指定运行批次 ID
  --stop-on-error         遇到失败立即停止
  -h, --help              显示帮助

示例：
  # 脚本放在 dnf_planner 目录下，测试 DNF-Benchmark-succes
  ./run-test-dnf.sh -t ./DNF-Benchmark-succes

  # 只测试一个领域
  ./run-test-dnf.sh -t ./DNF-Benchmark-succes -b 1-dispose-disappear

  # 只测试一个测例
  ./run-test-dnf.sh -t ./DNF-Benchmark-succes -b 1-dispose-disappear -p p2-5

  # 只测试 .al 文件
  ./run-test-dnf.sh -t ./benchmarks --mode al

  # 脚本放在项目根目录
  ./run-test-dnf.sh -t ./benchmarks --dnf-dir ./dnf_planner
USAGE
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --root) ROOT_DIR="$2"; shift 2 ;;
        -t|--test-root) TEST_ROOT="$2"; shift 2 ;;
        --dnf-dir|--dnf-planner-dir) DNF_PLANNER_DIR="$2"; shift 2 ;;
        --dnf-bin) DNF_BIN="$2"; shift 2 ;;
        --run-cpah) RUN_CPAH="$2"; shift 2 ;;
        --mode) MODE="$2"; shift 2 ;;
        -b|--benchmark) BENCHMARK_FILTER="$2"; shift 2 ;;
        -p|--problem) PROBLEM_FILTER="$2"; shift 2 ;;
        --timeout) TIMEOUT_SEC="$2"; shift 2 ;;
        --mem-gb) MEM_GB="$2"; shift 2 ;;
        -l|--log-root) LOG_ROOT_BASE="$2"; shift 2 ;;
        -r|--result-root) RESULT_ROOT_BASE="$2"; shift 2 ;;
        --run-id) RUN_ID="$2"; shift 2 ;;
        --stop-on-error) STOP_ON_ERROR=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "[错误] 未知参数：$1" >&2; usage; exit 1 ;;
    esac
done

if [[ "$MODE" != "auto" && "$MODE" != "pddl" && "$MODE" != "al" ]]; then
    echo "[错误] --mode 只能是 auto / pddl / al" >&2
    exit 1
fi

if [[ ! "$TIMEOUT_SEC" =~ ^[0-9]+$ || "$TIMEOUT_SEC" -le 0 ]]; then
    echo "[错误] --timeout 必须是正整数" >&2
    exit 1
fi

if [[ ! "$MEM_GB" =~ ^[0-9]+$ || "$MEM_GB" -le 0 ]]; then
    echo "[错误] --mem-gb 必须是正整数" >&2
    exit 1
fi
MEM_KB=$((MEM_GB * 1024 * 1024))

ROOT_DIR="$(cd "$ROOT_DIR" 2>/dev/null && pwd)"
if [[ -z "$ROOT_DIR" ]]; then
    echo "[错误] 无法解析 root 目录" >&2
    exit 1
fi

# 自动识别 dnf_planner：
#   情况 1：脚本就在 dnf_planner 内，当前目录有 dnf 和 run_cpah.sh
#   情况 2：脚本在项目根目录，子目录 dnf_planner 内有 dnf 和 run_cpah.sh
if [[ -z "$DNF_PLANNER_DIR" ]]; then
    if [[ -x "$ROOT_DIR/dnf" && -f "$ROOT_DIR/run_cpah.sh" ]]; then
        DNF_PLANNER_DIR="$ROOT_DIR"
    else
        DNF_PLANNER_DIR="$ROOT_DIR/dnf_planner"
    fi
fi
DNF_PLANNER_DIR="$(cd "$DNF_PLANNER_DIR" 2>/dev/null && pwd)"
if [[ -z "$DNF_PLANNER_DIR" || ! -d "$DNF_PLANNER_DIR" ]]; then
    echo "[错误] 找不到 dnf_planner 目录，请用 --dnf-dir 指定" >&2
    exit 1
fi

[[ -z "$DNF_BIN" ]] && DNF_BIN="$DNF_PLANNER_DIR/dnf"
[[ -z "$RUN_CPAH" ]] && RUN_CPAH="$DNF_PLANNER_DIR/run_cpah.sh"

if [[ ! -x "$DNF_BIN" ]]; then
    echo "[错误] DNF 可执行文件不存在或不可执行：$DNF_BIN" >&2
    echo "[提示] 执行 chmod +x $DNF_BIN" >&2
    exit 1
fi

if [[ "$MODE" != "al" && ! -x "$RUN_CPAH" ]]; then
    echo "[错误] run_cpah.sh 不存在或不可执行：$RUN_CPAH" >&2
    echo "[提示] 执行 chmod +x $RUN_CPAH $DNF_PLANNER_DIR/sic_script.sh" >&2
    exit 1
fi

# 默认测试目录兼容常见命名
if [[ -z "$TEST_ROOT" ]]; then
    if [[ -d "$ROOT_DIR/DNF-Benchmark-succes" ]]; then
        TEST_ROOT="$ROOT_DIR/DNF-Benchmark-succes"
    elif [[ -d "$DNF_PLANNER_DIR/DNF-Benchmark-succes" ]]; then
        TEST_ROOT="$DNF_PLANNER_DIR/DNF-Benchmark-succes"
    elif [[ -d "$ROOT_DIR/Benchmark" ]]; then
        TEST_ROOT="$ROOT_DIR/Benchmark"
    elif [[ -d "$ROOT_DIR/benchmarks" ]]; then
        TEST_ROOT="$ROOT_DIR/benchmarks"
    else
        TEST_ROOT="$ROOT_DIR/Benchmark"
    fi
fi

TEST_ROOT="$(cd "$TEST_ROOT" 2>/dev/null && pwd)"
if [[ -z "$TEST_ROOT" || ! -d "$TEST_ROOT" ]]; then
    echo "[错误] 找不到测试目录，请用 -t 指定：$TEST_ROOT" >&2
    exit 1
fi

[[ -z "$LOG_ROOT_BASE" ]] && LOG_ROOT_BASE="$ROOT_DIR/dnf_test_logs"
[[ -z "$RESULT_ROOT_BASE" ]] && RESULT_ROOT_BASE="$ROOT_DIR/dnf_result_output_batch"
mkdir -p "$LOG_ROOT_BASE" "$RESULT_ROOT_BASE"

LOG_ROOT_BASE="$(cd "$LOG_ROOT_BASE" && pwd)"
RESULT_ROOT_BASE="$(cd "$RESULT_ROOT_BASE" && pwd)"
LOG_ROOT="$LOG_ROOT_BASE/$RUN_ID"
RESULT_ROOT="$RESULT_ROOT_BASE/$RUN_ID"

SUMMARY_LOG="$LOG_ROOT/summary.log"
FAILED_CASES="$LOG_ROOT/failed_cases.txt"
ANOMALIES_LOG="$LOG_ROOT/anomalies.log"

mkdir -p "$LOG_ROOT" "$RESULT_ROOT"
: > "$SUMMARY_LOG"
: > "$FAILED_CASES"
: > "$ANOMALIES_LOG"

if command -v timeout >/dev/null 2>&1; then
    TIMEOUT_CMD="timeout"
elif command -v gtimeout >/dev/null 2>&1; then
    TIMEOUT_CMD="gtimeout"
else
    echo "[错误] 找不到 timeout/gtimeout" >&2
    exit 1
fi

log_summary() { printf '%s\n' "$*" >> "$SUMMARY_LOG"; }
log_anomaly() { printf '%s\n' "$*" | tee -a "$ANOMALIES_LOG" >> "$SUMMARY_LOG"; }

sanitize_name() {
    local s="$1"
    s="${s#./}"
    s="${s%/}"
    s="${s%.pddl}"
    s="${s%.pddl~}"
    s="${s%.al}"
    s="${s//\//__}"
    s="${s// /_}"
    s="${s//:/_}"
    s="${s//\\/__}"
    printf '%s' "$s"
}

strip_case_ext() {
    local s="$1"
    s="${s%.pddl}"
    s="${s%.pddl~}"
    s="${s%.al}"
    printf '%s' "$s"
}

matches_filter() {
    local case_name="$1"
    local file_base="$2"
    local suffix="$3"
    local rel_noext="$4"

    [[ -z "$PROBLEM_FILTER" ]] && return 0

    local f="$PROBLEM_FILTER"
    f="$(strip_case_ext "$f")"

    local b="$file_base"
    b="$(strip_case_ext "$b")"

    [[ "$case_name" == "$PROBLEM_FILTER" || "$case_name" == "$f" ]] && return 0
    [[ "$file_base" == "$PROBLEM_FILTER" || "$b" == "$f" ]] && return 0
    [[ -n "$suffix" && ( "$suffix" == "$PROBLEM_FILTER" || "$suffix" == "$f" ) ]] && return 0
    [[ -n "$rel_noext" && ( "$rel_noext" == "$PROBLEM_FILTER" || "$rel_noext" == "$f" ) ]] && return 0

    return 1
}

clean_intermediate() {
    (
        cd "$DNF_PLANNER_DIR" || exit 0
        rm -f dp.pddl pddl2pl.pl new.pl temp plan-result result-time trash
        rm -f theory_*.al
    ) 2>/dev/null || true
}

save_intermediate() {
    local result_dir="$1"
    local log_file="$2"
    local found_plan_result=1

    for f in plan-result result-time temp trash dp.pddl pddl2pl.pl new.pl; do
        if [[ -f "$DNF_PLANNER_DIR/$f" ]]; then
            cp -f "$DNF_PLANNER_DIR/$f" "$result_dir/" 2>/dev/null || true
            [[ "$f" == "plan-result" ]] && found_plan_result=0
        fi
    done

    shopt -s nullglob
    for f in "$DNF_PLANNER_DIR"/theory_*.al; do
        cp -f "$f" "$result_dir/" 2>/dev/null || true
    done
    shopt -u nullglob

    if [[ $found_plan_result -eq 0 ]]; then
        echo "[保存] plan-result -> $result_dir/plan-result" >> "$log_file"
    else
        echo "[保存] plan-result 缺失" >> "$log_file"
    fi

    return "$found_plan_result"
}

TOTAL=0
SUCCESS=0
FAILED=0
TIMEOUT_NUM=0
TRANSLATE_ERR=0
MISSING_PLAN_RESULT=0
NO_PLAN=0
SKIPPED=0
START_TS=$(date +%s)

record_result() {
    local bench="$1"
    local case_name="$2"
    local type="$3"
    local rc="$4"
    local elapsed="$5"
    local log_file="$6"
    local result_dir="$7"

    local plan_file="$result_dir/plan-result"
    local status=""

    if [[ "$rc" -eq 124 || "$rc" -eq 137 ]]; then
        status="TIMEOUT"
        FAILED=$((FAILED + 1))
        TIMEOUT_NUM=$((TIMEOUT_NUM + 1))

    # 只把明确的 PDDL 转换/脚本致命错误判为转换失败。
    # 不再用泛化的 "ERROR:"，避免 run_cpah.sh 正常完成但日志中出现非致命 ERROR 字样时被误判。
    elif [[ "$type" == "PDDL" ]] && grep -qiE "syntax error at symbol|cpa\.pddl2pl.*(No such file|not found|cannot execute|Exec format error|Permission denied)|sicstus: command not found|SICStus.*license|run_cpah\.sh.*(No such file|Permission denied)|sic_script\.sh.*(No such file|Permission denied)|pddl2pl\.pl.*No such file|theory_0\.al.*No such file|cannot execute binary file|Segmentation fault|core dumped" "$log_file"; then
        status="PDDL_TRANSLATE_OR_SCRIPT_ERROR"
        FAILED=$((FAILED + 1))
        TRANSLATE_ERR=$((TRANSLATE_ERR + 1))

    elif [[ ! -f "$plan_file" ]]; then
        status="NO_PLAN_RESULT"
        FAILED=$((FAILED + 1))
        MISSING_PLAN_RESULT=$((MISSING_PLAN_RESULT + 1))

    elif grep -q "Found a plan" "$plan_file"; then
        status="FOUND_PLAN"
        SUCCESS=$((SUCCESS + 1))
    elif grep -qiE "No plan|unsolvable|failed to find" "$plan_file"; then
        status="NO_PLAN"
        FAILED=$((FAILED + 1))
        NO_PLAN=$((NO_PLAN + 1))
    elif [[ "$rc" -eq 0 ]]; then
        status="EXIT0_NEED_CHECK"
        SUCCESS=$((SUCCESS + 1))
        log_anomaly "[需复核] $bench/$case_name：exit=0 但 plan-result 中没有 Found a plan，log=$log_file"
    else
        status="EXIT_CODE_$rc"
        FAILED=$((FAILED + 1))
    fi

    echo "$bench,$case_name,$type,$status,$rc,$elapsed,$log_file,$result_dir" >> "$SUMMARY_LOG"

    if [[ "$status" != "FOUND_PLAN" && "$status" != "EXIT0_NEED_CHECK" ]]; then
        echo "$bench/$case_name  type=$type status=$status exit_code=$rc elapsed=${elapsed}s log=$log_file result=$result_dir" >> "$FAILED_CASES"
        echo "[失败原因] $status" >> "$log_file"
    fi

    echo "[进度] benchmark=$bench case=$case_name type=$type status=$status elapsed=${elapsed}s success=$SUCCESS failed=$FAILED total=$TOTAL"

    if [[ "$status" != "FOUND_PLAN" && "$status" != "EXIT0_NEED_CHECK" && "$STOP_ON_ERROR" -eq 1 ]]; then
        echo "[停止] --stop-on-error 已启用，遇到失败后退出。"
        finalize_and_exit 1
    fi
}

run_pddl_case() {
    local bench="$1"
    local domain_file="$2"
    local problem_file="$3"
    local case_name="$4"
    local suffix="$5"

    local base
    base="$(basename "$problem_file")"
    matches_filter "$case_name" "$base" "$suffix" "" || return 0

    TOTAL=$((TOTAL + 1))

    local log_dir="$LOG_ROOT/$bench"
    local result_dir="$RESULT_ROOT/$bench/$case_name"
    local log_file="$log_dir/$case_name.log"
    mkdir -p "$log_dir"
    rm -rf "$result_dir"
    mkdir -p "$result_dir"

    clean_intermediate
    cp -f "$domain_file" "$result_dir/domain.pddl" 2>/dev/null || true
    cp -f "$problem_file" "$result_dir/problem.pddl" 2>/dev/null || true

    local start end elapsed rc
    start=$(date +%s)

    {
        echo "[开始时间] $(date '+%F %T')"
        echo "[类型] PDDL"
        echo "[benchmark] $bench"
        echo "[case] $case_name"
        echo "[domain] $domain_file"
        echo "[problem] $problem_file"
        echo "[dnf_dir] $DNF_PLANNER_DIR"
        echo "[command] cd $DNF_PLANNER_DIR && ./run_cpah.sh $domain_file $problem_file"
        echo "[timeout] ${TIMEOUT_SEC}s"
        echo "[mem] ${MEM_GB}GB"
        echo
    } > "$log_file"

    (
        cd "$DNF_PLANNER_DIR" || exit 1
        clean_intermediate
        ulimit -v "$MEM_KB" 2>/dev/null || true
        exec "$TIMEOUT_CMD" --signal=TERM --kill-after=10s "$TIMEOUT_SEC" \
            "$RUN_CPAH" "$domain_file" "$problem_file"
    ) >> "$log_file" 2>&1
    rc=$?

    end=$(date +%s)
    elapsed=$((end - start))

    {
        echo
        echo "[结束时间] $(date '+%F %T')"
        echo "[退出码] $rc"
        echo "[耗时秒] $elapsed"
    } >> "$log_file"

    save_intermediate "$result_dir" "$log_file" || true
    record_result "$bench" "$case_name" "PDDL" "$rc" "$elapsed" "$log_file" "$result_dir"
}

run_al_case() {
    local bench="$1"
    local al_file="$2"
    local rel_noext="$3"

    local base case_name
    base="$(basename "$al_file")"
    case_name="$(sanitize_name "$rel_noext")"
    matches_filter "$case_name" "$base" "" "$rel_noext" || return 0

    TOTAL=$((TOTAL + 1))

    local log_dir="$LOG_ROOT/$bench"
    local result_dir="$RESULT_ROOT/$bench/$case_name"
    local log_file="$log_dir/$case_name.log"
    local plan_file="$result_dir/plan-result"
    mkdir -p "$log_dir"
    rm -rf "$result_dir"
    mkdir -p "$result_dir"

    cp -f "$al_file" "$result_dir/input.al" 2>/dev/null || true

    local start end elapsed rc
    start=$(date +%s)

    {
        echo "[开始时间] $(date '+%F %T')"
        echo "[类型] AL"
        echo "[benchmark] $bench"
        echo "[case] $case_name"
        echo "[al_file] $al_file"
        echo "[dnf_dir] $DNF_PLANNER_DIR"
        echo "[command] cd $DNF_PLANNER_DIR && ./dnf $al_file"
        echo "[timeout] ${TIMEOUT_SEC}s"
        echo "[mem] ${MEM_GB}GB"
        echo
    } > "$log_file"

    (
        cd "$DNF_PLANNER_DIR" || exit 1
        ulimit -v "$MEM_KB" 2>/dev/null || true
        exec "$TIMEOUT_CMD" --signal=TERM --kill-after=10s "$TIMEOUT_SEC" \
            "$DNF_BIN" "$al_file"
    ) > "$plan_file" 2>&1
    rc=$?

    cat "$plan_file" >> "$log_file"

    end=$(date +%s)
    elapsed=$((end - start))

    {
        echo
        echo "[结束时间] $(date '+%F %T')"
        echo "[退出码] $rc"
        echo "[耗时秒] $elapsed"
        echo "[保存] plan-result -> $plan_file"
    } >> "$log_file"

    record_result "$bench" "$case_name" "AL" "$rc" "$elapsed" "$log_file" "$result_dir"
}

run_benchmark() {
    local bench_dir="$1"
    local bench
    bench="$(basename "$bench_dir")"

    [[ -n "$BENCHMARK_FILTER" && "$bench" != "$BENCHMARK_FILTER" ]] && return 0

    local before_total="$TOTAL"
    echo "[基准域开始] $bench"
    log_summary "[Benchmark] $bench"

    if [[ "$MODE" != "al" ]]; then
        local domain_file="$bench_dir/domain.pddl"

        if [[ -f "$domain_file" ]]; then
            local problem_file base case_name
            while IFS= read -r -d '' problem_file; do
                base="$(basename "$problem_file")"
                case_name="$(strip_case_ext "$base")"
                run_pddl_case "$bench" "$domain_file" "$problem_file" "$case_name" ""
            done < <(find "$bench_dir" -maxdepth 1 -type f \( -name '*.pddl' -o -name '*.pddl~' \) ! -name 'domain.pddl' -print0 | sort -z -V)
        else
            declare -A D_MAP=()
            declare -A P_MAP=()
            local d_file p_file d_base p_base key

            while IFS= read -r -d '' d_file; do
                d_base="$(basename "$d_file")"
                key="${d_base#d}"
                key="$(strip_case_ext "$key")"
                D_MAP["$key"]="$d_file"
            done < <(find "$bench_dir" -maxdepth 1 -type f -name 'd*.pddl' -print0 | sort -z -V)

            while IFS= read -r -d '' p_file; do
                p_base="$(basename "$p_file")"
                key="${p_base#p}"
                key="$(strip_case_ext "$key")"
                P_MAP["$key"]="$p_file"
            done < <(find "$bench_dir" -maxdepth 1 -type f \( -name 'p*.pddl' -o -name 'p*.pddl~' \) -print0 | sort -z -V)

            for key in $(printf '%s\n' "${!D_MAP[@]}" | sort -V); do
                if [[ -n "${P_MAP[$key]:-}" ]]; then
                    run_pddl_case "$bench" "${D_MAP[$key]}" "${P_MAP[$key]}" "p$key" "$key"
                else
                    log_anomaly "[异常] $bench：存在 d$key.pddl，但缺少 p$key.pddl / p$key.pddl~"
                fi
            done

            for key in $(printf '%s\n' "${!P_MAP[@]}" | sort -V); do
                if [[ -z "${D_MAP[$key]:-}" ]]; then
                    log_anomaly "[异常] $bench：存在 p$key.pddl，但缺少 d$key.pddl"
                fi
            done
        fi
    fi

    if [[ "$MODE" != "pddl" ]]; then
        local al_file rel rel_noext
        while IFS= read -r -d '' al_file; do
            rel="${al_file#$bench_dir/}"
            rel_noext="${rel%.al}"
            run_al_case "$bench" "$al_file" "$rel_noext"
        done < <(find "$bench_dir" -type f -name '*.al' -print0 | sort -z -V)
    fi

    if [[ "$TOTAL" -eq "$before_total" ]]; then
        SKIPPED=$((SKIPPED + 1))
        log_summary "[跳过] $bench：未发现匹配用例"
    else
        echo "[基准域完成] $bench cases=$((TOTAL - before_total))"
        log_summary "[Benchmark完成] $bench cases=$((TOTAL - before_total))"
    fi
}

finalize_and_exit() {
    local code="$1"
    local end_ts total_cost
    end_ts=$(date +%s)
    total_cost=$((end_ts - START_TS))

    {
        echo
        echo "[最终汇总]"
        echo "run_id=$RUN_ID"
        echo "root=$ROOT_DIR"
        echo "test_root=$TEST_ROOT"
        echo "dnf_dir=$DNF_PLANNER_DIR"
        echo "mode=$MODE"
        echo "total=$TOTAL"
        echo "success=$SUCCESS"
        echo "failed=$FAILED"
        echo "timeout=$TIMEOUT_NUM"
        echo "pddl_translate_or_script_error=$TRANSLATE_ERR"
        echo "missing_plan_result=$MISSING_PLAN_RESULT"
        echo "no_plan=$NO_PLAN"
        echo "skipped_benchmark=$SKIPPED"
        echo "total_elapsed=${total_cost}s"
        echo "log_root=$LOG_ROOT"
        echo "result_root=$RESULT_ROOT"
        echo "failed_cases=$FAILED_CASES"
        echo "anomalies=$ANOMALIES_LOG"
    } >> "$SUMMARY_LOG"

    echo "[完成] total=$TOTAL success=$SUCCESS failed=$FAILED elapsed=${total_cost}s"
    echo "[完成] summary=$SUMMARY_LOG"
    echo "[完成] result_root=$RESULT_ROOT"
    exit "$code"
}

trap 'echo; echo "[中断] 收到中断信号，正在退出。"; finalize_and_exit 130' INT TERM

log_summary "[开始] run_id=$RUN_ID"
log_summary "[开始] root=$ROOT_DIR"
log_summary "[开始] test_root=$TEST_ROOT"
log_summary "[开始] dnf_dir=$DNF_PLANNER_DIR"
log_summary "[开始] dnf_bin=$DNF_BIN"
log_summary "[开始] run_cpah=$RUN_CPAH"
log_summary "[开始] mode=$MODE timeout=${TIMEOUT_SEC}s mem=${MEM_GB}GB"
log_summary "[开始] log_root=$LOG_ROOT"
log_summary "[开始] result_root=$RESULT_ROOT"
[[ -n "$BENCHMARK_FILTER" ]] && log_summary "[过滤] benchmark=$BENCHMARK_FILTER"
[[ -n "$PROBLEM_FILTER" ]] && log_summary "[过滤] problem=$PROBLEM_FILTER"

echo "[开始] run_id=$RUN_ID mode=$MODE timeout=${TIMEOUT_SEC}s mem=${MEM_GB}GB"
echo "[开始] test_root=$TEST_ROOT"
echo "[开始] dnf_dir=$DNF_PLANNER_DIR"

FOUND_BENCH=0
while IFS= read -r -d '' bench_dir; do
    FOUND_BENCH=1
    run_benchmark "$bench_dir"
done < <(find "$TEST_ROOT" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z -V)

if [[ "$FOUND_BENCH" -eq 0 ]]; then
    echo "[错误] 测试根目录下没有 benchmark 子目录：$TEST_ROOT" >&2
    log_anomaly "[错误] 测试根目录下没有 benchmark 子目录：$TEST_ROOT"
    finalize_and_exit 1
fi

if [[ "$TOTAL" -eq 0 ]]; then
    echo "[错误] 没有发现任何可运行用例。检查 --mode、-b、-p 或测试目录结构。" >&2
    finalize_and_exit 1
fi

if [[ "$FAILED" -gt 0 ]]; then
    finalize_and_exit 1
else
    finalize_and_exit 0
fi

