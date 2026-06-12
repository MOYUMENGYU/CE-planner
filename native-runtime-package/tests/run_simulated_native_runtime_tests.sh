#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
BUILD=$(mktemp -d "${TMPDIR:-/tmp}/ce-native-test.XXXXXX")
trap 'rm -rf "$BUILD"' EXIT

CXX=${CXX:-g++}
"$CXX" -std=gnu++98 -Wall -Wextra -pedantic -fsyntax-only \
  -I"$ROOT/lama/search" "$ROOT/tests/native_runtime_syntax_test.cc"
"$CXX" -std=gnu++98 -Wall -Wextra -pedantic \
  -I"$ROOT/lama/search" "$ROOT/tests/native_runtime_integration_test.cc" \
  -o "$BUILD/native_runtime_integration_test"

BASE="$BUILD/fixture"
mkdir -p "$BASE/runs/current" "$BASE/input"
printf '(define (domain d))\n' > "$BASE/input/domain.pddl"
printf '(define (problem p) (:domain d))\n' > "$BASE/input/problem.pddl"
D="$BASE/input/domain.pddl"
P="$BASE/input/problem.pddl"
I="$BASE/runs/current"
BIN="$BUILD/native_runtime_integration_test"

mkdir -p "$BASE/T1"
cat > "$BASE/T1/t1" <<'EOF'
#!/bin/sh
pwd > cwd.seen
if [ "${FAKE_SKIP_RESULT:-0}" = 1 ]; then exit 0; fi
printf '(act)\n' > planner.result
EOF
chmod +x "$BASE/T1/t1"

mkdir -p "$BASE/cff"
cat > "$BASE/cff/ff" <<'EOF'
#!/bin/sh
pwd > cwd.seen
printf 'ff: found legal plan as follows\nstep 0: ACT\nstatistics:\n'
EOF
chmod +x "$BASE/cff/ff"

cat > "$BASE/fake-sicstus" <<'EOF'
#!/bin/sh
pwd > sicstus.cwd.seen
printf 'fake theory\n' > theory_0.al
printf 'theory_0.al\n' > theory_names
EOF
chmod +x "$BASE/fake-sicstus"

mkdir -p "$BASE/dnf" "$BASE/cpah"
for R in dnf cpah; do
  cat > "$BASE/$R/cpa.pddl2pl" <<'EOF'
#!/bin/sh
pwd > cpa.cwd.seen
printf '%% fake\n' > pddl2pl.pl
EOF
  printf '%% fake\n' > "$BASE/$R/mult5zsic.pl"
  chmod +x "$BASE/$R/cpa.pddl2pl"
done
printf '\n' > "$BASE/dnf/input"
cat > "$BASE/dnf/dnf" <<'EOF'
#!/bin/sh
pwd > solver.cwd.seen
printf 'Found a plan of length 1\nact()\n'
EOF
cat > "$BASE/cpah/CPAH" <<'EOF'
#!/bin/sh
pwd > solver.cwd.seen
printf 'Found a plan of length 1\nact()\n'
EOF
chmod +x "$BASE/dnf/dnf" "$BASE/cpah/CPAH"

for R in igc gclama; do
  mkdir -p "$BASE/$R/lama/translate" "$BASE/$R/lama/preprocess" "$BASE/$R/lama/search"
  printf '# fake translator\n' > "$BASE/$R/lama/translate/translate.py"
  cat > "$BASE/$R/fake-python" <<'EOF'
#!/bin/sh
pwd > python.cwd.seen
printf 'fake sas\n' > output.sas
printf 'translated\n'
EOF
  cat > "$BASE/$R/lama/preprocess/preprocess" <<'EOF'
#!/bin/sh
pwd > preprocess.cwd.seen
cat >/dev/null
printf 'fake output\n' > output
EOF
  cat > "$BASE/$R/lama/search/release-search" <<'EOF'
#!/bin/sh
pwd > search.cwd.seen
cat >/dev/null
printf '(act)\n' > finalplan
printf '没有反例，找到最终解！\n(act)\n'
EOF
  chmod +x "$BASE/$R/fake-python" "$BASE/$R/lama/preprocess/preprocess" \
    "$BASE/$R/lama/search/release-search"
done

mkdir -p "$BASE/gcpces/build" "$BASE/gcpces/libs"
: > "$BASE/gcpces/build/main.class"
printf '#!/bin/sh\nexit 0\n' > "$BASE/gcpces/ff"
chmod +x "$BASE/gcpces/ff"
cat > "$BASE/fake-java" <<'EOF'
#!/bin/sh
pwd > java.cwd.seen
out=''
while [ "$#" -gt 0 ]; do
  if [ "$1" = '-op' ]; then shift; out=$1; break; fi
  shift
done
[ -n "$out" ] || exit 3
printf 'act\n' > "$out"
printf 'ACT\n'
EOF
chmod +x "$BASE/fake-java"

IGC_T1_EXEC="$BASE/T1/t1" IGC_T1_ARGS='' "$BIN" 0 "$D" "$P" "$I"
IGC_CFF_DIR="$BASE/cff" "$BIN" 9 "$D" "$P" "$I"
IGC_DNF_DIR="$BASE/dnf" IGC_SICSTUS_EXEC="$BASE/fake-sicstus" \
  "$BIN" 2 "$D" "$P" "$I"
IGC_CPAH_DIR="$BASE/cpah" IGC_SICSTUS_EXEC="$BASE/fake-sicstus" \
  "$BIN" 4 "$D" "$P" "$I"
IGC_IGC_DIR="$BASE/igc" IGC_IGC_PYTHON="$BASE/igc/fake-python" \
  "$BIN" 5 "$D" "$P" "$I"
IGC_GC_LAMA_DIR="$BASE/gclama" IGC_GC_LAMA_PYTHON="$BASE/gclama/fake-python" \
  "$BIN" 6 "$D" "$P" "$I"
IGC_GCPCES_DIR="$BASE/gcpces" IGC_GCPCES_JAVA="$BASE/fake-java" \
  "$BIN" 7 "$D" "$P" "$I"
"$BIN" 8 "$D" "$P" "$I"

[[ $(cat "$BASE/T1/cwd.seen") == "$BASE/T1" ]]
[[ $(cat "$BASE/cff/cwd.seen") == "$BASE/cff" ]]
[[ $(cat "$BASE/dnf/solver.cwd.seen") == "$BASE/dnf" ]]
[[ $(cat "$BASE/cpah/solver.cwd.seen") == "$BASE/cpah" ]]
[[ $(cat "$BASE/igc/search.cwd.seen") == "$BASE/igc" ]]
[[ $(cat "$BASE/gclama/search.cwd.seen") == "$BASE/gclama" ]]
[[ $(cat "$BASE/gcpces/java.cwd.seen") == "$BASE/gcpces" ]]
[[ -f "$I/plan-result" ]]
[[ ! -d "$I/planner_work" ]]
if find "$BASE/runs" -mindepth 1 -maxdepth 1 -type d ! -name current | grep -q .; then
  echo '发现不应存在的 isolated 目录' >&2
  exit 1
fi

# Stale-result protection: a successful process that emits no new T1 plan must
# not reuse either the old native result or the old runs/current result.
printf '(stale)\n' > "$BASE/T1/planner.result"
printf '(stale)\n' > "$I/planner.result"
set +e
IGC_T1_EXEC="$BASE/T1/t1" IGC_T1_ARGS='' FAKE_SKIP_RESULT=1 \
  "$BIN" 0 "$D" "$P" "$I" >/dev/null 2>&1
RC=$?
set -e
[[ $RC -ne 0 ]]
[[ ! -e "$BASE/T1/planner.result" ]]
[[ ! -e "$I/planner.result" ]]

echo 'PASS: GNU++98 syntax, native cwd, runs/current output, overwrite and stale-result protection'
