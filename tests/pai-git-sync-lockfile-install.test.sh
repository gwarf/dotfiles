#!/usr/bin/env bash
# Hermetic tests for install_deps_if_lockfile_changed in pai-git-sync.
#
# The install must fire only when the pulled range touched package.json or the
# lockfile, and never reach the network otherwise. A stub `bun` on PATH records
# every call instead of installing anything.
#
# Run: bash tests/pai-git-sync-lockfile-install.test.sh

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TARGET="$SCRIPT_DIR/../home/private_dot_local/bin/executable_pai-git-sync"

if [ ! -f "$TARGET" ]; then
	printf 'FATAL: cannot find pai-git-sync at %s\n' "$TARGET" >&2
	exit 1
fi

TMPROOT=$(mktemp -d)
trap 'rm -rf "$TMPROOT"' EXIT

# shellcheck source=/dev/null
PAI_GIT_SYNC_SOURCED=1 HOME="$TMPROOT" . "$TARGET"
set +e

NOTIFIED=""
tg_notify() { NOTIFIED="$1"; }

CALLS="$TMPROOT/bun-calls"
mkdir -p "$TMPROOT/bin"
cat >"$TMPROOT/bin/bun" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"${BUN_CALLS:?}"
exit "${BUN_EXIT:-0}"
EOF
chmod +x "$TMPROOT/bin/bun"
export PATH="$TMPROOT/bin:$PATH" BUN_CALLS="$CALLS"

PASS=0
FAIL=0
check() {
	local label="$1" expected="$2" actual="$3"
	if [ "$expected" = "$actual" ]; then
		PASS=$((PASS + 1))
	else
		FAIL=$((FAIL + 1))
		printf 'FAIL: %s\n  expected: %s\n  actual:   %s\n' "$label" "$expected" "$actual" >&2
	fi
}

make_repo() {
	local repo="$1"
	git init -q "$repo"
	git -C "$repo" -c user.name=t -c user.email=t@t commit -q --allow-empty -m base
	printf '{}\n' >"$repo/package.json"
	printf 'lock v0\n' >"$repo/bun.lock"
	git -C "$repo" add package.json bun.lock
	git -C "$repo" -c user.name=t -c user.email=t@t commit -q -m deps
}

# Case 1: the pulled range touches only a source file, no install.
R1="$TMPROOT/r1"; make_repo "$R1"
BEFORE=$(git -C "$R1" rev-parse HEAD)
printf 'x\n' >"$R1/src.ts"; git -C "$R1" add src.ts; git -C "$R1" -c user.name=t -c user.email=t@t commit -q -m src
: >"$CALLS"
install_deps_if_lockfile_changed "$R1" r1 "$BEFORE"
check "source-only change installs nothing" "" "$(cat "$CALLS")"

# Case 2: the pulled range changes the lockfile, one frozen install.
R2="$TMPROOT/r2"; make_repo "$R2"
BEFORE=$(git -C "$R2" rev-parse HEAD)
printf 'lock v1\n' >"$R2/bun.lock"; git -C "$R2" add bun.lock; git -C "$R2" -c user.name=t -c user.email=t@t commit -q -m bump
: >"$CALLS"
install_deps_if_lockfile_changed "$R2" r2 "$BEFORE"
check "lockfile change runs one frozen install" "install --frozen-lockfile" "$(cat "$CALLS")"
check "a clean install notifies nothing" "" "$NOTIFIED"

# Case 3: the install fails, the sync is told and the function returns 1.
: >"$CALLS"; NOTIFIED=""
BUN_EXIT=1 install_deps_if_lockfile_changed "$R2" r2 "$BEFORE"
check "install failure returns 1" 1 "$?"
check "install failure notifies" "⚠️ pai-git-sync[r2]: bun install failed after a lockfile change" "$NOTIFIED"

# Case 4: a repo without a lockfile is left alone even when package.json moved.
R3="$TMPROOT/r3"; make_repo "$R3"; git -C "$R3" rm -q bun.lock; git -C "$R3" -c user.name=t -c user.email=t@t commit -q -m nolock
BEFORE=$(git -C "$R3" rev-parse HEAD)
printf '{"a":1}\n' >"$R3/package.json"; git -C "$R3" add package.json; git -C "$R3" -c user.name=t -c user.email=t@t commit -q -m pkg
: >"$CALLS"
install_deps_if_lockfile_changed "$R3" r3 "$BEFORE"
check "no lockfile means no install" "" "$(cat "$CALLS")"

printf '%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
