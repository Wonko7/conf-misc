#! /bin/sh


local win=$(tmux list-windows -F '#I:#W' | fzf-tmux | cut -d: -f1)
local session=$(tmux display-message -p '#S')
tmux select-window -t "$__tmux_session:$win" 2>&1 > /dev/null
