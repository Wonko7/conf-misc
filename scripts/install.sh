mkdir -p ~/.config
ln -s ~/conf/vim/vimrc ~/.vimrc
ln -s ~/conf/vim/gvimrc ~/.gvimrc
ln -s ~/conf/vim ~/.vim
ln -s ~/conf/vim ~/.config/nvim
ln -s ~/conf/vim/vimrc ~/.config/nvim/init.vim

ln -s ~/conf/zsh/zshrc ~/.zshrc
ln -s ~/conf/git/gitconfig ~/.gitconfig
ln -s ~/conf/misc/ackrc ~/.ackrc
ln -s ~/conf/misc/mostrc ~/.mostrc
ln -s ~/conf/misc/tmux.conf ~/.tmux.conf
ln -s ~/conf/misc/vimperatorrc ~/.vimperatorrc

ln -s ~/conf/xmonad ~/.xmonad

ln -s ~/conf/misc/xmodmap ~/.xmodmap
ln -s ~/conf/misc/lua ~/.lua
ln -s ~/conf/misc/xinitrc ~/.xinitrc
ln -s ~/conf/misc/xinitrc ~/.xsession
ln -s ~/conf/misc/xsession-kde.sh ~/.xsession-kde.sh
ln -s ~/conf/misc/Xdefaults ~/.Xdefaults
ln -s ~/conf/misc/Xresources ~/.Xresources
ln -s ~/conf/misc/conkyrc ~/.conkyrc
ln -s ~/conf/misc/lua ~/.lua
ln -s ~/conf/misc/compton.conf ~/.compton.conf
ln -s ~/conf/misc/xbindkeysrc ~/.bindkeysrc
ln -s ~/conf/misc/fonts.conf ~/.fonts.conf
ln -s ~/conf/misc/dunstrc ~/.dunstrc
ln -s ~/conf/misc/vimfx ~/.vimfx
ln -s ~/conf/misc/w3m ~/.w3m


echo "also: "
echo "  don't forget xmodmap -> check if default is good"
echo "  cd ~/conf/fonts && ./install.sh"
echo "  nvim dev-python: sexpdata neovim-python-client neovim-remote nrepl-python-client sexpdata websocket-client"
