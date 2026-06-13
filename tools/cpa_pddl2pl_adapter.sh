#!/bin/sh
set -eu

if [ "$#" -lt 1 ]; then
    echo "Usage: cpa_pddl2pl_adapter.sh <combined-pddl>" >&2
    exit 2
fi

python3 "$IGC_CPA_PDDL_ADAPTER" "$1"
exec "$IGC_CPA_REAL_PDDL2PL" "$@"
