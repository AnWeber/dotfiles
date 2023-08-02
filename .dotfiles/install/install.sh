#!/usr/bin/env bash
sudo apt update

if [ -f ~/.env ]
then
  export $(cat  ~/.env | xargs)
fi
if [ -f ~/work.env ]
then
  export $(cat  ~/work.env | xargs)
fi

~/.dotfiles/install/apps/git.sh
~/.dotfiles/install/apps/fonts.sh
~/.dotfiles/install/apps/xbindkeys.sh
~/.dotfiles/install/apps/pip.sh
~/.dotfiles/install/apps/zsh.sh
~/.dotfiles/install/apps/asdf.sh
~/.dotfiles/install/apps/docker.sh