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
# - 通过 PDDL 内容识别 domain/problem，不再只凭文件名猜测。
# - 配对优先级：d/p 精确配对 > domain_/instance_ > *_domain/prefix_* > 共享 domain。
# - 自动校验 domain/problem 声明的 domain 名，跳过并记录错配、孤立文件和重复配对。
# - 生成 cases.tsv，完整记录每个测例实际使用的 domain/problem 和配对规则。
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
  配对清单：  <log_root>/<run_id>/cases.tsv

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
CASE_MANIFEST="$LOG_ROOT/cases.tsv"

mkdir -p "$LOG_ROOT" "$RESULT_ROOT"
: > "$SUMMARY_LOG"
: > "$FAILED_CASES_FILE"
: > "$ANOMALIES_LOG"
printf 'case_id\tpair_type\tdomain_file\tproblem_file\n' > "$CASE_MANIFEST"

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
    if [[ $DRY_RUN -eq 1 ]]; then
        log_summary "[DRY-RUN] 跳过创建 options.py / instantiate.py。"
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
    if [[ $DRY_RUN -eq 1 ]]; then
        log_summary "[DRY-RUN] 跳过 Fast Downward 编译。"
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

case_id_for() {
    local bench_dir="$1"
    local case_name="$2"
    local rel
    if [[ "$bench_dir" == "$TEST_ROOT" ]]; then
        rel="$(basename "$bench_dir")"
    else
        rel="${bench_dir#$TEST_ROOT/}"
    fi
    printf '%s/%s\n' "$rel" "$case_name" | sed 's#[^A-Za-z0-9_./-]#_#g'
}

discover_cases() {
    declare -gA SEEN_CASES=()
    declare -ga CASE_BENCH_DIRS=()
    declare -ga CASE_DOMAINS=()
    declare -ga CASE_PROBLEMS=()
    declare -ga CASE_NAMES=()
    declare -ga CASE_SUFFIXES=()
    declare -ga CASE_PAIR_TYPES=()

    local scan_file record bench_dir domain_file problem_file case_name pair_suffix pair_type message
    scan_file="$(mktemp)"

    "$PYTHON_BIN" - "$TEST_ROOT" "$BENCHMARK_FILTER" "$PROBLEM_FILTER" > "$scan_file" <<'PYDISC'
import os
import re
import sys
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Tuple

root = Path(sys.argv[1]).resolve()
benchmark_filter = sys.argv[2]
problem_filter = sys.argv[3]

GENERATED_PATTERNS = (
    re.compile(r".*_sample(?:_plan)?\.pddl~?$", re.I),
    re.compile(r".*domain_conformant.*\.pddl~?$", re.I),
)


def natural_key(value: str):
    return [int(x) if x.isdigit() else x.lower() for x in re.split(r"(\d+)", value)]


def strip_ext(name: str) -> str:
    if name.endswith(".pddl~"):
        return name[:-6]
    if name.endswith(".pddl"):
        return name[:-5]
    return name


def generated_name(name: str) -> bool:
    return any(p.fullmatch(name) for p in GENERATED_PATTERNS)


def preferred_files(directory: Path) -> Dict[str, Path]:
    result: Dict[str, Path] = {}
    try:
        children = list(directory.iterdir())
    except OSError:
        return result
    for path in sorted(children, key=lambda p: natural_key(p.name)):
        if not path.is_file() or not (path.name.endswith(".pddl") or path.name.endswith(".pddl~")):
            continue
        if generated_name(path.name):
            continue
        stem = strip_ext(path.name)
        old = result.get(stem)
        if old is None or (old.name.endswith(".pddl~") and path.name.endswith(".pddl")):
            result[stem] = path.resolve()
    return result


PARSE_CACHE: Dict[Path, Tuple[str, Optional[str], Optional[str]]] = {}


def parse_pddl(path: Path) -> Tuple[str, Optional[str], Optional[str]]:
    """Return kind, declared domain name, referenced domain name."""
    if path in PARSE_CACHE:
        return PARSE_CACHE[path]
    try:
        text = path.read_text(encoding="utf-8", errors="replace")
    except OSError:
        result = ("unknown", None, None)
        PARSE_CACHE[path] = result
        return result
    text = re.sub(r";[^\n\r]*", " ", text)
    dm = re.search(r"\(\s*define\s*\(\s*domain\s+([^\s()]+)\s*\)", text, re.I | re.S)
    pm = re.search(r"\(\s*define\s*\(\s*problem\s+([^\s()]+)\s*\)", text, re.I | re.S)
    if dm:
        result = ("domain", dm.group(1).lower(), None)
    elif pm:
        ref = re.search(r"\(\s*:domain\s+([^\s()]+)\s*\)", text, re.I | re.S)
        result = ("problem", None, ref.group(1).lower() if ref else None)
    else:
        result = ("unknown", None, None)
    PARSE_CACHE[path] = result
    return result


anomalies: List[str] = []
cases: List[Tuple[Path, Path, Path, str, str, str]] = []
seen_pairs = set()
problem_owner: Dict[Path, Path] = {}


def benchmark_matches(bench_dir: Path) -> bool:
    if not benchmark_filter:
        return True
    try:
        rel = bench_dir.relative_to(root)
        parts = rel.parts if rel.parts else (bench_dir.name,)
    except ValueError:
        parts = (bench_dir.name,)
    return benchmark_filter in parts or bench_dir.name == benchmark_filter


def problem_matches(case_name: str, file_name: str, suffix: str) -> bool:
    if not problem_filter:
        return True
    f = problem_filter
    for ext in (".pddl~", ".pddl"):
        if f.endswith(ext):
            f = f[:-len(ext)]
            break
    if file_name == problem_filter or case_name in (problem_filter, f):
        return True
    if suffix and suffix in (problem_filter, f):
        return True
    variants = [case_name]
    if case_name.startswith("p_"):
        variants.append(case_name[2:])
    if case_name.startswith("p"):
        variants.append(case_name[1:])
    if case_name.startswith("instance_"):
        variants.append(case_name[len("instance_"):])
    return f in variants


def validate_pair(domain: Path, problem: Path, pair_type: str) -> bool:
    dk, dn, _ = parse_pddl(domain)
    pk, _, pn = parse_pddl(problem)
    if dk != "domain":
        anomalies.append(f"[配对错误] type={pair_type} 文件不是 domain：{domain} kind={dk}")
        return False
    if pk != "problem":
        anomalies.append(f"[配对错误] type={pair_type} 文件不是 problem：{problem} kind={pk}")
        return False
    if not dn or not pn:
        anomalies.append(f"[配对错误] type={pair_type} 无法读取 domain 声明 domain={domain} problem={problem}")
        return False
    if dn != pn:
        anomalies.append(
            f"[配对错误] type={pair_type} domain 名不一致 domain={domain} declares={dn} "
            f"problem={problem} uses={pn}"
        )
        return False
    return True


def append_case(bench: Path, domain: Path, problem: Path, case_name: str, suffix: str, pair_type: str):
    domain = domain.resolve()
    problem = problem.resolve()
    if not benchmark_matches(bench) or not problem_matches(case_name, problem.name, suffix):
        return
    if not validate_pair(domain, problem, pair_type):
        return
    owner = problem_owner.get(problem)
    if owner is not None and owner != domain:
        anomalies.append(
            f"[重复配对跳过] problem={problem} 已配 domain={owner}，"
            f"忽略候选 domain={domain} type={pair_type}"
        )
        return
    key = (domain, problem)
    if key in seen_pairs:
        return
    seen_pairs.add(key)
    problem_owner[problem] = domain
    cases.append((bench.resolve(), domain, problem, case_name, suffix, pair_type))


def nearest_domain(directory: Path) -> Optional[Path]:
    directory = directory.resolve()
    while directory == root or root in directory.parents:
        for name in ("domain.pddl", "domain_one.pddl"):
            candidate = directory / name
            if candidate.is_file() and parse_pddl(candidate.resolve())[0] == "domain":
                return candidate.resolve()
        if directory == root:
            break
        directory = directory.parent
    return None


directories = [root] + [p for p in root.rglob("*") if p.is_dir()]
directories.sort(key=lambda p: natural_key(str(p.relative_to(root)) if p != root else ""))

for bench in directories:
    if not benchmark_matches(bench):
        continue
    files = preferred_files(bench)
    d_map: Dict[str, Path] = {}
    p_map: Dict[str, Path] = {}
    domain_suffix: Dict[str, Path] = {}
    instance_suffix: Dict[str, Path] = {}
    prefix_domains: Dict[str, Path] = {}

    for stem, path in files.items():
        kind, _, _ = parse_pddl(path)
        if kind == "domain":
            if stem.startswith("d") and not stem.startswith("domain") and not stem.endswith("_domain"):
                d_map[stem[1:]] = path
            if stem.startswith("domain_"):
                domain_suffix[stem[len("domain_"):]] = path
            if stem.endswith("_domain"):
                prefix_domains[stem[:-len("_domain")]] = path
        elif kind == "problem":
            if stem.startswith("p"):
                p_map[stem[1:]] = path
            if stem.startswith("instance_"):
                instance_suffix[stem[len("instance_"):]] = path
        else:
            anomalies.append(f"[忽略] 无法识别 PDDL define 类型：{path}")

    # More specific naming conventions take precedence over shared domain.
    for suffix in sorted(d_map, key=natural_key):
        if suffix in p_map:
            append_case(bench, d_map[suffix], p_map[suffix], "p" + suffix, suffix, "d-p-pair")
        else:
            anomalies.append(f"[未配对 domain] {d_map[suffix]} 缺少 p{suffix}.pddl")

    for suffix in sorted(domain_suffix, key=natural_key):
        if suffix in instance_suffix:
            append_case(
                bench, domain_suffix[suffix], instance_suffix[suffix],
                "instance_" + suffix, suffix, "domain-instance-pair"
            )
        else:
            anomalies.append(f"[未配对 domain] {domain_suffix[suffix]} 缺少 instance_{suffix}.pddl")

    for prefix in sorted(prefix_domains, key=natural_key):
        matched = False
        for stem in sorted(files, key=natural_key):
            if stem == prefix + "_domain" or not stem.startswith(prefix + "_"):
                continue
            path = files[stem]
            if parse_pddl(path)[0] != "problem":
                continue
            append_case(bench, prefix_domains[prefix], path, stem, stem, "prefix-domain")
            matched = True
        if not matched:
            anomalies.append(f"[未配对 domain] {prefix_domains[prefix]} 未发现 {prefix}_*.pddl problem")

    shared: Optional[Path] = None
    if "domain" in files and parse_pddl(files["domain"])[0] == "domain":
        shared = files["domain"]
    if "domain_one" in files and parse_pddl(files["domain_one"])[0] == "domain":
        if shared is not None:
            anomalies.append(f"[多个共享 domain] dir={bench} 同时存在 domain.pddl 与 domain_one.pddl，优先 domain.pddl")
        else:
            shared = files["domain_one"]

    if shared is not None:
        for stem in sorted(files, key=natural_key):
            path = files[stem]
            if parse_pddl(path)[0] == "problem" and path.resolve() not in problem_owner:
                append_case(bench, shared, path, stem, "", "shared-domain")

        for child_name in ("instances", "unsat_instances", "unsat_instance"):
            child = bench / child_name
            if not child.is_dir():
                continue
            for stem, path in sorted(preferred_files(child).items(), key=lambda item: natural_key(item[0])):
                if parse_pddl(path)[0] == "problem":
                    append_case(bench, shared, path, stem, "", "parent-shared-domain")

    if bench.name in ("instances", "unsat_instances", "unsat_instance"):
        parent_domain = nearest_domain(bench.parent)
        if parent_domain is not None:
            for stem, path in sorted(files.items(), key=lambda item: natural_key(item[0])):
                if parse_pddl(path)[0] == "problem":
                    append_case(bench.parent, parent_domain, path, stem, "", "nearest-parent-domain")

    # Report still-unowned problems only when no shared domain can legitimately claim them.
    if shared is None:
        for stem, path in sorted(files.items(), key=lambda item: natural_key(item[0])):
            if parse_pddl(path)[0] == "problem" and path.resolve() not in problem_owner:
                anomalies.append(f"[未配对 problem] {path}")

for message in anomalies:
    print("ANOMALY\x1f" + message.replace("\x1f", " ").replace("\n", " "))
for bench, domain, problem, case_name, suffix, pair_type in cases:
    fields = ["CASE", str(bench), str(domain), str(problem), case_name, suffix, pair_type]
    print("\x1f".join(field.replace("\x1f", " ").replace("\n", " ") for field in fields))
PYDISC

    while IFS=$'\x1f' read -r record bench_dir domain_file problem_file case_name pair_suffix pair_type; do
        [[ -z "$record" ]] && continue
        if [[ "$record" == "ANOMALY" ]]; then
            message="$bench_dir"
            log_anomaly "$message"
        elif [[ "$record" == "CASE" ]]; then
            CASE_BENCH_DIRS+=("$bench_dir")
            CASE_DOMAINS+=("$domain_file")
            CASE_PROBLEMS+=("$problem_file")
            CASE_NAMES+=("$case_name")
            CASE_SUFFIXES+=("$pair_suffix")
            CASE_PAIR_TYPES+=("$pair_type")
        fi
    done < "$scan_file"
    rm -f "$scan_file"
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

has_valid_icpces_plan() {
    local log_file="$1"

    "$PYTHON_BIN" - "$log_file" <<'PYPLAN'
import ast
import re
import sys

path = sys.argv[1]
try:
    lines = open(path, "r", encoding="utf-8", errors="replace").read().splitlines()
except OSError:
    raise SystemExit(1)

for i, line in enumerate(lines):
    if line.strip().lower() != "find a valid plan":
        continue
    j = i + 1
    while j < len(lines) and not lines[j].strip():
        j += 1
    if j >= len(lines) or lines[j].strip().lower() == "none":
        continue

    candidate = ""
    plan = None
    k = j
    while k < len(lines) and k < j + 10000:
        candidate += ("\n" if candidate else "") + lines[k]
        try:
            value = ast.literal_eval(candidate.strip())
        except (SyntaxError, ValueError):
            k += 1
            continue
        if isinstance(value, (list, tuple)):
            plan = value
        break
    if plan is None:
        continue

    declared = None
    for m in range(k + 1, min(len(lines), k + 200)):
        match = re.fullmatch(r"\s*plan length:\s*(\d+)\s*", lines[m], flags=re.I)
        if match:
            declared = int(match.group(1))
            break
    if declared is not None and declared == len(plan):
        raise SystemExit(0)
raise SystemExit(1)
PYPLAN
}

classify_result() {
    local rc="$1"
    local log_file="$2"

    if [[ "$rc" -eq 124 ]]; then
        echo "TIMEOUT"; return 0
    fi
    if [[ "$rc" -eq 137 ]]; then
        echo "KILLED_OR_MEMORY_LIMIT"; return 0
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

    if has_valid_icpces_plan "$log_file"; then
        if [[ "$rc" -eq 0 ]]; then
            echo "FOUND_PLAN"
        else
            echo "FOUND_PLAN_WITH_NONZERO_EXIT_${rc}"
        fi
        return 0
    fi

    if grep -Eiq "Traceback \(most recent call last\)|Exception|AssertionError|AttributeError|TypeError|ValueError|KeyError|IndexError|FileNotFoundError|Permission denied|cannot execute" "$log_file"; then
        echo "PYTHON_OR_RUNTIME_ERROR"; return 0
    fi
    if grep -Eiq "Search stopped without finding a solution|(^|[^A-Za-z])no solution([^A-Za-z]|$)|unsolvable" "$log_file"; then
        echo "NO_SOLUTION_OR_FAILED"; return 0
    fi
    if grep -Eiq "conformant planning time:|sampling time:|FD search time:" "$log_file"; then
        echo "FINISHED_NEED_CHECK"; return 0
    fi
    if [[ "$rc" -eq 0 ]]; then
        echo "EXIT0_NO_RECOGNIZED_PLAN"
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
    log_summary "[汇总] 配对清单=$CASE_MANIFEST"
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
    local pair_type="$6"

    local case_id case_log_dir case_result_dir case_log_file start_ts end_ts elapsed rc status cmd_string
    case_id="$(case_id_for "$bench_dir" "$case_name")"
    case_log_dir="$LOG_ROOT/$(dirname "$case_id")"
    case_result_dir="$RESULT_ROOT/$case_id"
    case_log_file="$case_log_dir/$(basename "$case_id").log"

    if [[ $DRY_RUN -eq 1 ]]; then
        RUN_DOMAIN="$domain_file"
        RUN_PROBLEM="$problem_file"
        resolve_command_args "$RUN_DOMAIN" "$RUN_PROBLEM"
        printf -v cmd_string '%q ' "${CMD[@]}"
        echo "[DRY-RUN] $idx/$DISCOVERED_CASES case=$case_id"
        echo "  domain=$domain_file"
        echo "  problem=$problem_file"
        echo "  pair_type=$pair_type"
        echo "  command=cd $ROOT_DIR && $cmd_string"
        return 0
    fi

    mkdir -p "$case_log_dir" "$case_result_dir"
    prepare_case_inputs "$domain_file" "$problem_file" "$case_result_dir"
    resolve_command_args "$RUN_DOMAIN" "$RUN_PROBLEM"
    printf '%q ' "${CMD[@]}" > "$case_result_dir/command.txt"
    printf '\n' >> "$case_result_dir/command.txt"
    cmd_string="$(cat "$case_result_dir/command.txt")"

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
        echo "[pair_type] $pair_type"
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

for i in "${!CASE_DOMAINS[@]}"; do
    case_id="$(case_id_for "${CASE_BENCH_DIRS[$i]}" "${CASE_NAMES[$i]}")"
    printf '%s\t%s\t%s\t%s\n' \
        "$case_id" "${CASE_PAIR_TYPES[$i]}" "${CASE_DOMAINS[$i]}" "${CASE_PROBLEMS[$i]}" >> "$CASE_MANIFEST"
done

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
    run_one_case "$n" "${CASE_BENCH_DIRS[$i]}" "${CASE_DOMAINS[$i]}" "${CASE_PROBLEMS[$i]}" "${CASE_NAMES[$i]}" "${CASE_PAIR_TYPES[$i]}"
    if [[ $STOP_REQUESTED -eq 1 ]]; then
        break
    fi
done

finalize_summary
ELAPSED=$(($(date +%s) - START_TS))
echo "[完成] total=$TOTAL_CASES success=$SUCCESS_CASES failed=$FAILED_CASES elapsed=${ELAPSED}s"
echo "[完成] summary=$SUMMARY_LOG"
echo "[完成] result_root=$RESULT_ROOT"
echo "[完成] cases_manifest=$CASE_MANIFEST"

if [[ $STOP_REQUESTED -eq 1 ]]; then
    exit "$STOP_REQUESTED_EXIT_CODE"
fi
if [[ $FAILED_CASES -gt 0 ]]; then
    exit 1
fi
exit 0
