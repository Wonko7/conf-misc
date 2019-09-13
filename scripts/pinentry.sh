#! /bin/sh

if [ "$PINENTRY_USER_DATA" = 1 ]; then
  exec /usr/bin/pinentry-curses "$@"
else
  exec /usr/bin/pinentry-qt "$@"
fi
