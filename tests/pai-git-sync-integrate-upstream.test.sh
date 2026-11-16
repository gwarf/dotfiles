#!/usr/bin/env bash
# integrate_upstream must survive the two states a slow commit leaves behind:
# origin moved since the first fetch, and new unstaged writes in the tree.

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TARGET="$SCRIPT_DIR/../home/private_dot_local/bin/executable_pai-git-sync"

TMPROOT=$(mktemp -d)
trap 'rm -rf "$TMPROOT"' EXIT

# shellcheck source=/dev/null
PAI_GIT_SYNC_SOURCED=1 HOME="$TMPROOT" XDG_STATE_HOME="$TMPROOT/state" . "$TARGET"
set +e

export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@example.invalid
export GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@example.invalid

PASS=0
FAIL=0
check() {
	if [ "$2" = "$3" ]; then PASS=$((PASS + 1)); else
		FAIL=$((FAIL + 1))
		printf 'FAIL: %s: expected [%s] got [%s]\n' "$1" "$3" "$2"
	fi
}

git init -q --bare -b main "$TMPROOT/origin.git"
git clone -q "$TMPROOT/origin.git" "$TMPROOT/host" 2>/dev/null
git clone -q "$TMPROOT/origin.git" "$TMPROOT/other" 2>/dev/null
cd "$TMPROOT/host" || exit 1
printf 'a\n' >shared && printf 'live\n' >log && git add . && git commit -qm base && git push -q origin main
git -C "$TMPROOT/other" pull -q origin main

# Origin moves after the host's commit, and a live writer dirties the tree.
printf 'host\n' >hostfile && git add hostfile && git commit -qm host
printf 'other\n' >"$TMPROOT/other/otherfile"
git -C "$TMPROOT/other" add otherfile && git -C "$TMPROOT/other" commit -qm other && git -C "$TMPROOT/other" push -q origin main
printf 'live2\n' >>log

integrate_upstream host >/dev/null 2>&1
check "moved origin + dirty tree integrates" "$?" "0"
check "other host's commit is underneath" "$(git log --format=%s -3 | tr '\n' ' ')" "host other base "
check "unstaged write survives" "$(tail -n1 log)" "live2"
check "push is now a fast-forward" "$(git push -q origin main 2>&1; echo $?)" "0"
check "no failure recorded" "$([ -e "$FAILURE_LOG" ] && echo yes || echo no)" "no"

# A real conflict still aborts cleanly and is recorded.
git checkout -q -- log
printf 'host-side\n' >shared && git commit -qam host-conflict
git -C "$TMPROOT/other" pull -q origin main
printf 'other-side\n' >"$TMPROOT/other/shared"
git -C "$TMPROOT/other" commit -qam other-conflict && git -C "$TMPROOT/other" push -q origin main

integrate_upstream host >/dev/null 2>&1
check "conflict returns failure" "$?" "1"
check "no rebase left in progress" "$([ -d .git/rebase-merge ] || [ -d .git/rebase-apply ] && echo yes || echo no)" "no"
check "conflict recorded" "$(grep -c 'rebase conflict' "$FAILURE_LOG")" "1"

printf '%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
