#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ADAPTER="$SCRIPT_DIR/cpa_refined_adapter"
[ -x "$ADAPTER" ] || {
    echo "Missing $ADAPTER; run ./build first." >&2
    exit 1
}

TMP=$(mktemp -d "${TMPDIR:-/tmp}/ce-cpa-adapter-test.XXXXXX")
trap 'rm -rf "$TMP"' EXIT HUP INT TERM

cat > "$TMP/two.pddl" <<'PDDL'
(define (domain d)
  (:requirements :negative-preconditions)
  (:predicates (p) (q) (done)
               (igc-ce-test-sel-0000) (igc-ce-test-sel-0001))
  (:action set-p :parameters () :precondition (and) :effect (p))
  (:action set-q :parameters () :precondition (and) :effect (q)))
(define (problem x)
  (:domain d)
  (:init (and
    (not (done))
    (oneof (igc-ce-test-sel-0000) (igc-ce-test-sel-0001))
    (or (not (igc-ce-test-sel-0000)) (not (p)))
    (or (not (igc-ce-test-sel-0000)) (not (q)))
    (or (not (igc-ce-test-sel-0001)) (p))
    (or (not (igc-ce-test-sel-0001)) (q))))
  (:goal (and (p) (q))))
PDDL

"$ADAPTER" "$TMP/two.pddl"
grep -q '"encoding": "native-two-world-2cnf"' "$TMP/cpa-pddl-adapter.json"
! grep -q 'igc-ce-test-sel' "$TMP/two.pddl"
grep -q '(oneof' "$TMP/two.pddl"
grep -q '(p)' "$TMP/two.pddl"
grep -q '(q)' "$TMP/two.pddl"

echo "CPA C++ refined-PDDL adapter regression: PASS"
