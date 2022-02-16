if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_CUSTOM_AUTOUPDATE_QUIET=true
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7
ENABLE_CORRECTION="false"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#1e88e5"

plugins=(
  autoupdate
  common-aliases
  git
  gpg-agent
  z
  zsh-autosuggestions
  zsh-better-npm-completion
)

xbindkeys -f ~/.xbindkeysrc

for file in $(find ~ -maxdepth 1 -name '*.env' -type f -prune | sort -nr  | tac ); do
  export $(cat "$file" | xargs);
done


export PATH="$HOME/.dotfiles/bin:$PATH"

[[ ! -f ~/.dotfiles/zsh/default.zsh ]] || source ~/.dotfiles/zsh/default.zsh
[[ ! -f ~/${LOCALENV}.zsh ]] || source ~/${LOCALENV}.zsh

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh
setopt globdots

export GPG_TTY=$(tty)
