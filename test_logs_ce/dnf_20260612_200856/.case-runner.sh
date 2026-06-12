#!/usr/bin/env bash
set -u
root_dir=$1
memory_kb=$2
timeout_cmd=$3
timeout_sec=$4
plan_script=$5
domain_file=$6
problem_file=$7
result_file=$8
display_flag=$9
time_cmd=${10:-}

cd "$root_dir" || exit 126
ulimit -v "$memory_kb" || {
    echo "[RESOURCE] failed to set ulimit -v=$memory_kb" >&2
    exit 125
}

if [[ -n "$time_cmd" ]]; then
    exec "$time_cmd" -v "$timeout_cmd" --signal=TERM --kill-after=10s "$timeout_sec" \
        bash "$plan_script" "$domain_file" "$problem_file" "$result_file" "$display_flag"
else
    exec "$timeout_cmd" --signal=TERM --kill-after=10s "$timeout_sec" \
        bash "$plan_script" "$domain_file" "$problem_file" "$result_file" "$display_flag"
fi
