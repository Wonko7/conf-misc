#! /bin/sh

userresources=$HOME/.Xresources
sysresources=/etc/X11/xinit/Xresources


if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/* ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

#xset fp+ /usr/share/fonts/terminus
xset fp+ ~/.local/share/fonts

source ~/conf/zsh/env.zsh
source ~/conf/zsh/guix.zsh
(~/.xsession-user.sh&)

exec xmonad
