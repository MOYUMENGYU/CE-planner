#!/bin/sh
set -eu

if [ "$#" -ne 4 ]; then
    echo "Usage: plan-cegis <domain.pddl> <problem.pddl> <result_file> <true|false>" >&2
    exit 1
fi

# : "${IGC_CANDIDATE_RUNTIME_MODE:=isolated}"
# export IGC_CANDIDATE_RUNTIME_MODE
: "${IGC_CANDIDATE_PLANNER:?Set IGC_CANDIDATE_PLANNER to t1, cff, cnf, dnf, pip, cpah, igc, gc_lama, gcpces, or icpces}"

case "$1" in
    /*) DOMAIN_FILE=$1 ;;
    *)  DOMAIN_FILE=$PWD/$1 ;;
esac
case "$2" in
    /*) PROBLEM_FILE=$2 ;;
    *)  PROBLEM_FILE=$PWD/$2 ;;
esac

export IGC_ORIGINAL_DOMAIN="$DOMAIN_FILE"
export IGC_ORIGINAL_PROBLEM="$PROBLEM_FILE"
export IGC_CEGIS_MODE=1
export IGC_REFINED_MODE="${IGC_REFINED_MODE:-structured}"
export IGC_REFINED_VALIDATION="${IGC_REFINED_VALIDATION:-basic}"
export IGC_CANDIDATE_TIMEOUT="${IGC_CANDIDATE_TIMEOUT:-3600}"
export IGC_CEGIS_MAX_ITERATIONS="${IGC_CEGIS_MAX_ITERATIONS:-100}"
export IGC_CEGIS_DUPLICATE_LIMIT="${IGC_CEGIS_DUPLICATE_LIMIT:-2}"

case "$IGC_CANDIDATE_PLANNER" in
    t1|T1)
        export IGC_CANDIDATE_PLANNER=t1
        export IGC_T1_EXEC="${IGC_T1_EXEC:-$PWD/T1/t1}"
        ;;
    cff|CFF|ff|FF|conformant_ff|conformant-ff|Conformant-FF)
        export IGC_CANDIDATE_PLANNER=cff
        if [ -z "${IGC_CFF_DIR:-}" ]; then
            if [ -d "$PWD/conformant-ff" ]; then
                IGC_CFF_DIR=$PWD/conformant-ff
            elif [ -d "$PWD/Conformant-FF" ]; then
                IGC_CFF_DIR=$PWD/Conformant-FF
            elif [ -d "$PWD/CFF" ]; then
                IGC_CFF_DIR=$PWD/CFF
            elif [ -d "$PWD/cff" ]; then
                IGC_CFF_DIR=$PWD/cff
            else
                IGC_CFF_DIR=$PWD/conformant-ff
            fi
        fi
        export IGC_CFF_DIR
        export IGC_CFF_EXEC="${IGC_CFF_EXEC:-$IGC_CFF_DIR/ff}"
        ;;
    cnf|CNF|cnf_planner)
        export IGC_CANDIDATE_PLANNER=cnf
        export IGC_CNF_DIR="${IGC_CNF_DIR:-$PWD/cnf_planner}"
        ;;
    dnf|DNF|dnf_planner)
        export IGC_CANDIDATE_PLANNER=dnf
        export IGC_DNF_DIR="${IGC_DNF_DIR:-$PWD/dnf_planner}"
        ;;
    pip|PIP|pip_planner)
        export IGC_CANDIDATE_PLANNER=pip
        export IGC_PIP_DIR="${IGC_PIP_DIR:-$PWD/pip_planner}"
        ;;
    cpah|CPAH|cpa_h|cpah_planner)
        export IGC_CANDIDATE_PLANNER=cpah
        if [ -z "${IGC_CPAH_DIR:-}" ]; then
            if [ -d "$PWD/CpAH" ]; then
                IGC_CPAH_DIR=$PWD/CpAH
            elif [ -d "$PWD/CPAH" ]; then
                IGC_CPAH_DIR=$PWD/CPAH
            elif [ -d "$PWD/cpah_planner" ]; then
                IGC_CPAH_DIR=$PWD/cpah_planner
            else
                IGC_CPAH_DIR=$PWD/CpAH
            fi
        fi
        export IGC_CPAH_DIR
        ;;
    igc|iGC|igc_origin|igc-origin|original_igc)
        export IGC_CANDIDATE_PLANNER=igc
        if [ -z "${IGC_IGC_DIR:-}" ]; then
            if [ -d "$PWD/iGC/lama" ]; then
                IGC_IGC_DIR=$PWD/iGC
            elif [ -d "$PWD/iGC-origin/gc_counter/lama" ]; then
                IGC_IGC_DIR=$PWD/iGC-origin/gc_counter
            elif [ -d "$PWD/iGC-origin/lama" ]; then
                IGC_IGC_DIR=$PWD/iGC-origin
            elif [ -d "$PWD/igc-origin/gc_counter/lama" ]; then
                IGC_IGC_DIR=$PWD/igc-origin/gc_counter
            else
                IGC_IGC_DIR=$PWD/iGC
            fi
        fi
        export IGC_IGC_DIR
        export IGC_IGC_PYTHON="${IGC_IGC_PYTHON:-${IGC_GC_PYTHON:-python2}}"
        ;;
    gc|GC|gc_lama|GC_LAMA|gc-lama|GC-LAMA|gclama)
        export IGC_CANDIDATE_PLANNER=gc_lama
        if [ -z "${IGC_GC_LAMA_DIR:-}" ]; then
            if [ -d "$PWD/GC_LAMA/lama" ]; then
                IGC_GC_LAMA_DIR=$PWD/GC_LAMA
            elif [ -d "$PWD/GC-LAMA/lama" ]; then
                IGC_GC_LAMA_DIR=$PWD/GC-LAMA
            elif [ -d "$PWD/gc_lama/lama" ]; then
                IGC_GC_LAMA_DIR=$PWD/gc_lama
            else
                IGC_GC_LAMA_DIR=$PWD/GC_LAMA
            fi
        fi
        export IGC_GC_LAMA_DIR
        export IGC_GC_LAMA_PYTHON="${IGC_GC_LAMA_PYTHON:-${IGC_GC_PYTHON:-python2}}"
        ;;
    gcpces|GCPCES|g_cpces|g-cpces|cpces|CPCES)
        export IGC_CANDIDATE_PLANNER=gcpces
        if [ -z "${IGC_GCPCES_DIR:-}" ]; then
            if [ -d "$PWD/gCPCES" ]; then
                IGC_GCPCES_DIR=$PWD/gCPCES
            elif [ -d "$PWD/GCPCES" ]; then
                IGC_GCPCES_DIR=$PWD/GCPCES
            elif [ -d "$PWD/CPCES" ]; then
                IGC_GCPCES_DIR=$PWD/CPCES
            else
                IGC_GCPCES_DIR=$PWD/gCPCES
            fi
        fi
        export IGC_GCPCES_DIR
        export IGC_GCPCES_JAVA="${IGC_GCPCES_JAVA:-java}"
        ;;
    icpces|ICPCES|i_cpces|i-cpces)
        export IGC_CANDIDATE_PLANNER=icpces
        if [ -z "${IGC_ICPCES_DIR:-}" ]; then
            if [ -d "$PWD/iCPCES" ]; then
                IGC_ICPCES_DIR=$PWD/iCPCES
            elif [ -d "$PWD/ICPCES" ]; then
                IGC_ICPCES_DIR=$PWD/ICPCES
            elif [ -d "$PWD/icpces" ]; then
                IGC_ICPCES_DIR=$PWD/icpces
            else
                IGC_ICPCES_DIR=$PWD/iCPCES
            fi
        fi
        export IGC_ICPCES_DIR
        export IGC_ICPCES_PYTHON="${IGC_ICPCES_PYTHON:-python3}"
        ;;
    *)
        echo "Unsupported IGC_CANDIDATE_PLANNER: $IGC_CANDIDATE_PLANNER" >&2
        exit 1
        ;;
esac

exec ./plan "$DOMAIN_FILE" "$PROBLEM_FILE" "$3" "$4"
