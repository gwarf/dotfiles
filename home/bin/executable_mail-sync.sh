#!/bin/sh

MBSYNC=$(pgrep mbsync)
NOTMUCH=$(pgrep notmuch)

if [ -n "$MBSYNC" ] || [ -n "$NOTMUCH" ]; then
  echo "Already running one instance of mbsync or notmuch. Exiting..."
  exit 0
fi

# TODO: check if programs are available

# Only run if notmuch DB is aleady initialized
if [ -d ~/Mail/.notmuch/xapian ]; then

  # Move tagged messages to the related folders (i.e. all, spam, sent or trash)
  # XXX: with Gmail all messages are already in the all folders
  echo "Move tagged messages to the relevant folder"
  afew --move --all --verbose

  # This can be used to definitely delete messages, skipping the trash
  # echo "Deleting local messages tagged as *deleted*"
  # notmuch search --format=text0 --output=files tag:deleted | xargs -0 --no-run-if-empty rm -v

  echo "Removing inbox tag from sent messages"
  notmuch tag -inbox -- "tag:sent and tag:inbox"
fi

# Synchronize all mailboxes
mbsync --verbose --all

# Tag new messages, afew runs as post hook
notmuch new
