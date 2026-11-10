#!/usr/bin/env bash
# record_failure appends a timestamped line to the host-local failure log
# instead of notifying anyone; the agent's status commands read that file.

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TARGET="$SCRIPT_DIR/../home/private_dot_local/bin/executable_pai-git-sync"

TMPROOT=$(mktemp -d)
trap 'rm -rf "$TMPROOT"' EXIT

# shellcheck source=/dev/null
PAI_GIT_SYNC_SOURCED=1 HOME="$TMPROOT" XDG_STATE_HOME="$TMPROOT/state" . "$TARGET"
set +e

PASS=0
FAIL=0
check() {
	if [ "$2" = "$3" ]; then PASS=$((PASS + 1)); else
		FAIL=$((FAIL + 1))
		printf 'FAIL: %s: expected [%s] got [%s]\n' "$1" "$3" "$2"
	fi
}

check "log path is under XDG_STATE_HOME" "$FAILURE_LOG" "$TMPROOT/state/pai-git-sync/failures"

record_failure "first failure"
record_failure "second failure"
check "two lines appended" "$(wc -l <"$FAILURE_LOG" | tr -d ' ')" "2"
check "message after the tab" "$(tail -n1 "$FAILURE_LOG" | cut -f2)" "second failure"
check "ISO timestamp first" "$(head -n1 "$FAILURE_LOG" | cut -f1 | grep -cE '^[0-9]{4}-[0-9]{2}-[0-9]{2}T')" "1"

printf '%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
