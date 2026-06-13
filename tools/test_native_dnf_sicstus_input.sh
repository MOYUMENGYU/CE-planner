#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP/dnf" "$TMP/run"
printf '(define (domain d))\n' > "$TMP/domain.pddl"
printf '(define (problem p))\n' > "$TMP/problem.pddl"
printf '(corrupted old input)\n' > "$TMP/dnf/input"
printf '%% base\n' > "$TMP/dnf/mult5zsic.pl"
cat > "$TMP/dnf/cpa.pddl2pl" <<'SCRIPT'
#!/bin/sh
printf '%% generated\n' > pddl2pl.pl
SCRIPT
cat > "$TMP/fake-sicstus" <<'SCRIPT'
#!/bin/sh
IFS= read -r first || exit 71
IFS= read -r second || exit 72
[ "$first" = y ] || exit 73
[ "$second" = y ] || exit 74
printf 'theory\n' > theory_0.al
printf 'accepted deterministic input\n'
SCRIPT
cat > "$TMP/dnf/dnf" <<'SCRIPT'
#!/bin/sh
printf 'Found a plan of length 1\n'
printf '(act)\n'
SCRIPT
chmod +x "$TMP/dnf/cpa.pddl2pl" "$TMP/dnf/dnf" "$TMP/fake-sicstus"
cp "$ROOT/lama/search/cegis_native_runtime.inc" "$TMP/cegis_native_runtime.inc"
g++ -std=gnu++98 -Wall -Wextra -pedantic \
    -I"$TMP" "$ROOT/tools/native_runtime_integration_test.cc" \
    -o "$TMP/test-native"
IGC_DNF_DIR="$TMP/dnf" IGC_SICSTUS_EXEC="$TMP/fake-sicstus" \
    "$TMP/test-native" 2 "$TMP/domain.pddl" "$TMP/problem.pddl" "$TMP/run"
printf 'y\ny\n' > "$TMP/expected"
cmp "$TMP/expected" "$TMP/run/sicstus.input"
grep -q '^[(]corrupted' "$TMP/dnf/input"
grep -qi 'found a plan' "$TMP/run/plan-result"
echo 'PASS: native DNF ignores corrupted solver input and uses deterministic per-run SICStus input'
