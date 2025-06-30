#!/bin/sh

MBSYNC=$(pgrep mbsync)
NOTMUCH=$(pgrep notmuch)

if [ -n "$MBSYNC" -o -n "$NOTMUCH" ]; then
    echo "Already running one instance of mbsync or notmuch. Exiting..."
    exit 0
fi

# Move tagged messages to the related folders (i.e. spam and junk)
afew --move --all --verbose

echo "Deleting messages tagged as *deleted*"
notmuch search --format=text0 --output=files tag:deleted | xargs -0 --no-run-if-empty rm -v

# Retrieve new messages
mbsync --verbose --all

# Tag new messages, afew runs as post hook
notmuch new
