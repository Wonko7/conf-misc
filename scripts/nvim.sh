#!/bin/sh

## this binds a single nvim per desktop. Any terminal on that desktop will send files to it.
## vim is run in a tmux session which will be re-attached if the terminal is closed.

if [ "$REMOTE_SESSION" = 1 ]; then
  nvim $@
  exit $?
fi

if [ -z $VIM_SERVER ]; then
  VIM_SERVER=nvim_`wmctrl -d | sed -nre "/\*/ s/^([0-9]+).*/\1/p"`
fi

SOCKET_PREFIX=/tmp/nvimsockets
nvr_cmd="nvr -s --servername $SOCKET_PREFIX/$VIM_SERVER $@"

current_desktop_id=$(wmctrl -d | sed -nre 's/^([0-9]+)\s+\*.*$/\1/p')

mkdir -p $SOCKET_PREFIX
if nvr --serverlist | egrep -q "^$SOCKET_PREFIX/$VIM_SERVER\$"; then
  # send file open to existing session:
  $nvr_cmd
  # find vim window and raise:
  vim_line=$(wmctrl -l | grep $VIM_SERVER)
  vim_window=$(echo $vim_line | cut -d' ' -f1)
  vim_desktop=$(echo $vim_line | awk '{print $2}')
  if [ -z $vim_window ]; then
    # window closed, open a new one and attach to session:
    (~/conf/misc/scripts/st.sh -t $VIM_SERVER -e tmux attach-session -t auto_$VIM_SERVER&)
  else
    # raise:
    ## if [ $current_desktop_id = $vim_window[1] ]; then
    ##   # raise doesn't work with multiple monitors.
    ##   #wmctrl -i -R $vim_window[0]
    ##   wmctrl -a $vim_window[0]
    ## fi
    if [ $VIM_SERVER != DANCE_COMMANDER ]; then
      wmctrl -i -a $vim_window
      # else, focus 2nd monitor on DANCE_COMMANDER?
    fi
  fi
else
  # new session:
  (~/conf/misc/scripts/st.sh -t $VIM_SERVER -e tmux new-session -s auto_$VIM_SERVER "$nvr_cmd" \; set status off \;&)
fi
