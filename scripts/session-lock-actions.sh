#!/bin/sh

xscreensaver-command -watch | while read xs; do
  case "$xs" in
    LOCK*)
      killall -s SIGUSR1 dunst
      ;;
    UNBLANK*)
      killall -s SIGUSR2 dunst
      killall -s SIGHUP notif
      ;;
  esac
done
