#!/bin/sh

# WIP.

if [ -z $EMACS_SERVER ]; then
  EMACS_SERVER=EMACS_$(wmctrl -d | sed -nre "/\*/ s/^([0-9]+).*/\1/p")
fi

emacsclient -s $EMACS_SERVER -c $@&
