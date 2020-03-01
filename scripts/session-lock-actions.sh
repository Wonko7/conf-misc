#!/bin/sh

xscreensaver-command -watch | while read xs; do
  case "$xs" in
    LOCK*)
      svc-s6 -1 $s6/notif || killall -s SIGUSR1 dunst
      svc-s6 -1 $s6/dunst || killall -s SIGUSR1 notif
      ;;
    UNBLANK*)
      svc-s6 -2 $s6/notif || killall -s SIGUSR2 dunst
      svc-s6 -2 $s6/dunst || killall -s SIGUSR2 notif
      ;;
  esac
done
