#!/usr/bin/env bash
# Hermetic tests for clear_stale_index_lock in pai-git-sync.
#
# That function runs `rm` unattended on a timer, so the cases that matter are
# the ones where it must NOT fire: a lock a live git still holds, or one whose
# staleness cannot be proven. Every case builds its own throwaway repo.
#
# Run: bash tests/pai-git-sync-stale-lock.test.sh

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TARGET="$SCRIPT_DIR/../home/private_dot_local/bin/executable_pai-git-sync"

if [ ! -f "$TARGET" ]; then
	printf 'FATAL: cannot find pai-git-sync at %s\n' "$TARGET" >&2
	exit 1
fi

TMPROOT=$(mktemp -d)
trap 'rm -rf "$TMPROOT"' EXIT

# Redirecting HOME keeps the real ~/.env out of reach, so BOT_TOKEN stays empty
# and no test can reach Telegram even if the stub below is dropped.
# shellcheck source=/dev/null
PAI_GIT_SYNC_SOURCED=1 HOME="$TMPROOT" . "$TARGET"

# The sourced script sets -e; "left it alone" is a normal return of 1 here.
set +e

NOTIFIED=""
tg_notify() {
	NOTIFIED="$1"
}

PASS=0
FAIL=0

check() {
	local label="$1" expected="$2" actual="$3"
	if [ "$expected" = "$actual" ]; then
		PASS=$((PASS + 1))
		printf '  ok   %s\n' "$label"
	else
		FAIL=$((FAIL + 1))
		printf '  FAIL %s (expected %q, got %q)\n' "$label" "$expected" "$actual"
	fi
}

new_repo() {
	local repo
	repo=$(mktemp -d "$TMPROOT/repo.XXXXXX")
	mkdir -p "$repo/.git"
	printf '%s' "$repo"
}

stale() {
	touch -d '30 minutes ago' "$1"
}

lock_state() {
	if [ -e "$1" ] || [ -L "$1" ]; then printf 'present'; else printf 'gone'; fi
}

check_notified() {
	local label="$1" needle="$2"
	case "$NOTIFIED" in
	*"$needle"*) check "$label" 'yes' 'yes' ;;
	*) check "$label" 'yes' "$NOTIFIED" ;;
	esac
}

printf 'clear_stale_index_lock\n'

repo=$(new_repo)
NOTIFIED=""
clear_stale_index_lock "$repo" test
check 'no lock: reports nothing cleared' 1 "$?"
check 'no lock: stays quiet' '' "$NOTIFIED"

repo=$(new_repo)
: >"$repo/.git/index.lock"
NOTIFIED=""
clear_stale_index_lock "$repo" test
check 'fresh lock: left alone' 1 "$?"
check 'fresh lock: still there' 'present' "$(lock_state "$repo/.git/index.lock")"
check 'fresh lock: stays quiet' '' "$NOTIFIED"

repo=$(new_repo)
: >"$repo/.git/index.lock"
stale "$repo/.git/index.lock"
NOTIFIED=""
clear_stale_index_lock "$repo" test >/dev/null
check 'stale empty unheld lock: cleared' 0 "$?"
check 'stale empty unheld lock: removed' 'gone' "$(lock_state "$repo/.git/index.lock")"
check_notified 'stale empty unheld lock: announced' 'cleared stale index.lock'

repo=$(new_repo)
printf 'DIRC' >"$repo/.git/index.lock"
stale "$repo/.git/index.lock"
NOTIFIED=""
clear_stale_index_lock "$repo" test
check 'non-empty lock: left alone' 1 "$?"
check 'non-empty lock: still there' 'present' "$(lock_state "$repo/.git/index.lock")"
check_notified 'non-empty lock: flagged for a human' 'non-empty'

# Doubles as a positive control on fuser: if this passes for the wrong reason,
# the "cleared" case above cannot be trusted either.
repo=$(new_repo)
: >"$repo/.git/index.lock"
stale "$repo/.git/index.lock"
exec 9<"$repo/.git/index.lock"
NOTIFIED=""
clear_stale_index_lock "$repo" test
check 'held lock: left alone' 1 "$?"
check 'held lock: still there' 'present' "$(lock_state "$repo/.git/index.lock")"
exec 9<&-

# The rm must not follow a symlink out of the repo.
repo=$(new_repo)
printf 'do not touch' >"$TMPROOT/bystander"
ln -s "$TMPROOT/bystander" "$repo/.git/index.lock"
stale "$TMPROOT/bystander"
NOTIFIED=""
clear_stale_index_lock "$repo" test
check 'symlink lock: left alone' 1 "$?"
check 'symlink lock: link intact' 'present' "$(lock_state "$repo/.git/index.lock")"
check 'symlink lock: target untouched' 'do not touch' "$(cat "$TMPROOT/bystander")"

repo=$(new_repo)
: >"$repo/.git/index.lock"
stale "$repo/.git/index.lock"
stub="$TMPROOT/stubbin"
mkdir -p "$stub"
for bin in stat date rm; do
	ln -sf "$(command -v "$bin")" "$stub/$bin"
done
NOTIFIED=""
saved_path="$PATH"
PATH="$stub"
clear_stale_index_lock "$repo" test
rc=$?
PATH="$saved_path"
check 'no fuser: left alone' 1 "$rc"
check 'no fuser: still there' 'present' "$(lock_state "$repo/.git/index.lock")"
check_notified 'no fuser: flagged for a human' 'fuser'

printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
