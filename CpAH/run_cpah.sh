#!/bin/sh

# Running CPA(H) with Sicstus Prolog.
# This wrapper preserves the exit code of sic_script.sh.
/usr/bin/time -f "Total time: %e (seconds)" -o result-time ./sic_script.sh "$1" "$2"
rc=$?

if [ -f result-time ]; then
    cat result-time
fi

exit $rc
