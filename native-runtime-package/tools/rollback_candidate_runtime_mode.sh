#!/usr/bin/env bash
set -euo pipefail
REPO=${1:-.}
SRC="$REPO/lama/search/cegis_framework.cc"
SRC_BAK="$SRC.bak-native-runtime"
MK="$REPO/lama/search/Makefile"
MK_BAK="$REPO/lama/search/Makefile.bak-native-runtime"

[[ -f "$SRC_BAK" ]] || { echo "缺少备份：$SRC_BAK" >&2; exit 1; }
[[ -f "$MK_BAK" ]] || { echo "缺少备份：$MK_BAK" >&2; exit 1; }
cp -f "$SRC_BAK" "$SRC"
cp -f "$MK_BAK" "$MK"
echo "已恢复：$SRC"
echo "已恢复：$MK"
echo "cegis_native_runtime.inc 保留，不参与编译；确认无需后可手工删除。"
