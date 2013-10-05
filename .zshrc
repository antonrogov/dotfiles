# .zshrc

for config_file ($HOME/.zsh/functions/*.zsh); do
  source $config_file
done

alias h='history 25'
alias j='jobs -l'
alias la='ls -a'
alias ll='ls -lA'
alias ff='find . -name'
alias view='vim -R'
alias v='view -'

alias sst='svn status'
sd() { svn diff $* | v }
alias sca='svn commit'
alias scam='svn commit -m'

alias gst='git status'
alias gaa='git add --all'
alias gl='git pull'
alias gp='git push'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gb='git branch'
alias gba='git branch -a'
gbl() { git blame $* | v }
gd() { git diff $* | v }
gdc() { git diff --cached $* | v }
gsl() { git stash list }
gss() { git stash show -p "stash@{$*}" | v }
gsd() { git stash drop "stash@{$*}" }
gsp() { git stash pop "stash@{$*}" }
glr() { pretty_git_log --all -30 $* }
gla() { pretty_git_log --all $* }

alias reload!='. ~/.zshrc'
alias fetch='curl -C - -O'

if [[ -n $SSH_CONNECTION ]]; then
  export PS1=$'%{\e]0;%n@%m\a%}%{\e[0;31m%}%m:%3~$%{\e[0m%} '
else
  if [[ -n $VIMRUNTIME ]]; then
    export PS1=$'%3~$ '
  else
    export PS1=$'%{\e]0;%n@%m\a%}%{\e[0;32m%}%3~$%{\e[0m%} '
  fi
fi

export EDITOR='vim'
export CLICOLOR='1'
export LSCOLORS='exfxcxdxbxexexexexexhx'
export LC_CTYPE=en_US.UTF-8
export ACK_COLOR_MATCH='red'
export GREP_OPTIONS='--color'

HISTFILE=~/.history
HISTSIZE=100000
SAVEHIST=$HISTSIZE
REPORTTIME=10 # print elapsed time when more than 10 seconds
WORDCHARS="${WORDCHARS:s#/#}"

setopt NO_BG_NICE
setopt NO_HUP
setopt NO_LIST_BEEP
setopt NO_HIST_BEEP
setopt CSH_JUNKIE_LOOPS
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt COMPLETE_IN_WORD

compctl -C -c -f -tn
compctl -c sudo

bindkey '\e[A' q-history-search-backward
bindkey '\e[B' q-history-search-forward
bindkey '\e[1;5C' forward-word
bindkey '\e[1;5D' backward-word
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '\e[3~' delete-char
bindkey '\e[9~' backward-delete-word

[[ -s ~/.zshrc.local ]] && . ~/.zshrc.local
