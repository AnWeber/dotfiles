# dotfiles

https://www.atlassian.com/git/tutorials/dotfiles

### Init
```
git init --bare $HOME/.dotfiles_repo
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles_repo/ --work-tree=$HOME'
config config status.showUntrackedFiles no
```


### Install
```
git clone --separate-git-dir=$HOME/.dotfiles_repo https://github.com/AnWeber/dotfiles.git $HOME/.dotfiles-tmp
rm -rf ~/.dotfiles-tmp/
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles_repo/ --work-tree=$HOME'
config config status.showUntrackedFiles no
config checkout .
```

or

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/AnWeber/dotfiles/main/.dotfiles/install/init.sh)"
```
