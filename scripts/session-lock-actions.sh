#!/bin/sh

xscreensaver-command -watch | while read xs; do
  case "$xs" in
    LOCK*)
      echo "locking & yielding:"
      s6-svc -1 ~/conf/s6-services/notif || killall -s SIGUSR1 dunst
      s6-svc -1 ~/conf/s6-services/dunst || killall -s SIGUSR1 notif
      ;;
    UNBLANK*)
      echo "unlocking & seizing:"
      s6-svc -2 ~/conf/s6-services/notif || killall -s SIGUSR2 dunst
      s6-svc -2 ~/conf/s6-services/dunst || killall -s SIGUSR2 notif
      ;;
  esac
done
