#! /bin/sh

if [ "$PINENTRY_USER_DATA" = 1 ]; then
  #exec /gnu/store/jsdzxvfwj1z2lwrd15gqhmmvgp40hzqk-profile/bin/pinentry-curses "$@"
  exec pinentry-curses "$@"
else
  exec pinentry-qt "$@"
fi
