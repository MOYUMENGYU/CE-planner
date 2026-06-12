#!/bin/sh
set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT HUP INT TERM

mkdir -p "$TMP_DIR/lama/translate" \
         "$TMP_DIR/lama/preprocess" \
         "$TMP_DIR/lama/search" \
         "$TMP_DIR/tools"
cp "$REPO_ROOT/plan" "$TMP_DIR/plan"
cp "$REPO_ROOT/tools/filter_cegis_groups.py" \
   "$TMP_DIR/tools/filter_cegis_groups.py"
chmod +x "$TMP_DIR/plan"

cat > "$TMP_DIR/lama/translate/translate.py" <<'EOF'
#!/bin/sh
cat > output.sas <<'SAS'
begin_variables
4
var0 2 -1
var1 2 0
var2 2 -1
var3 2 0
end_variables
SAS
cat > all.groups <<'GROUPS'
begin_groups
4
group
1
0 0 low 1 x1
group
1
1 0 new-axiom@0 0
group
1
2 0 high 1 z2
group
1
3 0 new-axiom@1 0
end_groups
GROUPS
printf 'translated\n'
EOF
chmod +x "$TMP_DIR/lama/translate/translate.py"

cat > "$TMP_DIR/lama/preprocess/preprocess" <<'EOF'
#!/bin/sh
cat >/dev/null
printf 'preprocessed\n' > output
EOF
chmod +x "$TMP_DIR/lama/preprocess/preprocess"

cat > "$TMP_DIR/lama/search/release-search" <<'EOF'
#!/bin/sh
printf '%s\n' "$IGC_ALL_GROUPS" > observed_groups_path
cat "$IGC_ALL_GROUPS" > observed_groups_content
EOF
chmod +x "$TMP_DIR/lama/search/release-search"

printf '(define (domain d))\n' > "$TMP_DIR/domain.pddl"
printf '(define (problem p))\n' > "$TMP_DIR/problem.pddl"

(
    cd "$TMP_DIR"
    IGC_CEGIS_MODE=1 \
    IGC_ALL_GROUPS="$TMP_DIR/all.groups" \
    ./plan domain.pddl problem.pddl result.plan false

    test "$(cat observed_groups_path)" = "$TMP_DIR/cegis.groups"
    test "$(sed -n '2p' observed_groups_content)" = "2"
    if grep -q '@' observed_groups_content; then
        echo "derived predicate leaked into CEGIS groups" >&2
        exit 1
    fi
)

echo "PASS: CEGIS search receives the filtered base-fluent map"
