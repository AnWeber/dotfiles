
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles_repo/ --work-tree=$HOME'

configInit(){
   config pull
   sh ~/.dotfiles/install/install.sh
}