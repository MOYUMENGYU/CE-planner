#!/bin/sh

rm -f pddl2pl.pl new.pl theory_names temp plan-result trash pddl2pl.log dp.pddl

if [ -n "$2" ]; then
    echo
    echo "Creating dp.pddl file from $1 and $2"
    cat "$1" "$2" > dp.pddl
    input_file="dp.pddl"
else
    echo
    echo "Using single input file $1"
    input_file="$1"
fi

echo "Converting PDDL to Prolog ..."
./cpa.pddl2pl "$input_file" > pddl2pl.log 2>&1
rc=$?
cat pddl2pl.log
if [ $rc -ne 0 ] || [ ! -s pddl2pl.pl ]; then
    echo "[CPAH-ERROR] cpa.pddl2pl failed. input=$input_file exit_code=$rc"
    exit 10
fi

echo "Performing statistical analysis ..."
cat mult5zsic.pl pddl2pl.pl > new.pl
rc=$?
if [ $rc -ne 0 ] || [ ! -s new.pl ]; then
    echo "[CPAH-ERROR] failed to build new.pl exit_code=$rc"
    exit 11
fi

sicstus -l new.pl --goal 'main,halt.' > trash 2>&1
rc=$?
if [ $rc -ne 0 ] || [ ! -s theory_names ]; then
    echo "[CPAH-ERROR] SICStus analysis failed. exit_code=$rc"
    echo "[CPAH-ERROR] Last 120 lines of trash:"
    tail -n 120 trash 2>/dev/null
    exit 20
fi

echo "Running CPA+ ..."
./CPAH theory_names > temp 2>&1
rc=$?
if [ $rc -ne 0 ]; then
    echo "[CPAH-ERROR] CPAH failed. exit_code=$rc"
    echo "[CPAH-ERROR] Last 120 lines of temp:"
    tail -n 120 temp 2>/dev/null
    exit 30
fi

sed -e 's/cpa_//g' temp > plan-result
cat plan-result
exit 0
