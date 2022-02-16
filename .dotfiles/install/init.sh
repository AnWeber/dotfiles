git clone --separate-git-dir=$HOME/.dotfiles_repo https://github.com/AnWeber/dotfiles.git $HOME/.dotfiles-tmp
rm -rf ~/.dotfiles-tmp/
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles_repo/ --work-tree=$HOME'
config config status.showUntrackedFiles no
config checkout .