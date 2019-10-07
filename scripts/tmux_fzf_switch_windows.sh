#! /bin/sh

if [ ! -z "$1" ]; then
  __tmux_session=$1
fi
win=$(tmux list-windows -F '#I:#W' | sk-tmux | cut -d: -f1)

tmux select-window -t "$__tmux_session:$win" 2>&1 > /dev/null
