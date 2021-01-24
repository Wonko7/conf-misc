HOST=$(hostname)

mkdir -p ~/.config/nvim
ln -snf ~/conf/vim/vimrc                ~/.vimrc
ln -snf ~/conf/vim/gvimrc               ~/.gvimrc
ln -snf ~/conf/vim                      ~/.vim
ln -snf ~/conf/vim                      ~/.config/nvim
ln -snf ~/conf/vim/vimrc                ~/.config/nvim/init.vim

ln -snf ~/conf/xmonad                   ~/.xmonad
ln -snf ~/conf/zsh/zshrc                ~/.zshrc

ln -snf ~/conf/misc/generated/gitconfig ~/.gitconfig
ln -snf ~/conf/misc/tmux.conf           ~/.tmux.conf

ln -snf ~/conf/misc/user-dirs.dirs      ~/.config/user-dirs.dirs

ln -snf ~/conf/misc/w3m                 ~/.w3m
ln -snf ~/conf/misc/mostrc              ~/.mostrc

ln -snf ~/conf/misc/generated/$HOST.picom.conf ~/.config/picom.conf
ln -snf ~/conf/misc/vimfx               ~/.vimfx

ln -snf ~/conf/misc/xinitrc             ~/.xinitrc
ln -snf ~/conf/misc/xsession            ~/.xsession
ln -snf ~/conf/misc/xsession-user.sh    ~/.xsession-user.sh

ln -snf ~/conf/misc/XCompose            ~/.XCompose
ln -snf ~/conf/misc/Xdefaults           ~/.Xdefaults
ln -snf ~/conf/misc/Xresources          ~/.Xresources
ln -snf ~/conf/misc/xscreensaver        ~/.xscreensaver

ln -snf ~/conf/misc/fonts.conf          ~/.fonts.conf

ln -snf ~/conf/emacs                    ~/.emacs.d
ln -snf ~/conf/doom                     ~/.doom.d

# host dependent:
case $HOST in
  daban-urnud|yggdrasill)
    echo git with gpg signing!
    ln -snf ~/conf/misc/generated/sign.gitconfig ~/.gitconfig
    ;;
  *)
    echo git without gpg signing!
    ln -snf ~/conf/misc/generated/gitconfig       ~/.gitconfig
    ;;
esac

# begin+emacs
mkdir -p ~/.local/share/applications/

ln -snf ~/conf/misc/emacs/org-protocol.desktop ~/.local/share/applications/org-protocol.desktop

update-desktop-database ~/.local/share/applications/
kbuildsycoca5
xdg-mime default org-protocol.desktop x-scheme-handler/org-protocol
# end

echo "also: "
echo "  don't forget xmodmap -> check if default is good"
echo "  cd ~/conf/fonts && ./install.sh"
echo "  nvim: dev-python: sexpdata neovim-python-client neovim-remote nrepl-python-client sexpdata websocket-client"
echo "  xmonad: dev-haskell/hostname"
echo "  zsh: bookmarks, history, tmux-sessions"
