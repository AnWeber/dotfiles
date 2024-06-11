export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM_AUTOUPDATE_QUIET=true
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7
ENABLE_CORRECTION="false"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#1e88e5"

plugins=(
  autoupdate
  gpg-agent
  volta
  zoxide
  zsh-autosuggestions
  zsh-better-npm-completion
)
zstyle ':omz:plugins:eza' 'git-status' yes

xbindkeys -f ~/.xbindkeysrc

for file in $(find ~ -maxdepth 1 -name '*.env' -type f -prune | sort -nr  | tac ); do
  export $(cat "$file" | xargs);
done


export PATH="$HOME/.local/bin:$HOME/.dotfiles/bin:$PATH"

source $HOME/.asdf/asdf.sh

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh
setopt globdots


export STARSHIP_CONFIG=~/.dotfiles/zsh/starship.toml
eval "$(starship init zsh)"
alias starhship_refresh="$(eval "$(starship init zsh)")"

[[ ! -f ~/.dotfiles/zsh/index.zsh ]] || source ~/.dotfiles/zsh/index.zsh
[[ ! -f ~/${LOCALENV}.zsh ]] || source ~/${LOCALENV}.zsh

export GPG_TTY=$(tty)
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export RIPGREP_CONFIG_PATH="$HOME/.dotfiles/settings/.ripgreprc"
