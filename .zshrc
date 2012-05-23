# .zshrc

alias h='history 25'
alias j='jobs -l'
alias la='ls -a'
alias ll='ls -lA --color=auto'
alias ff='find . -name'
alias view='vim -R -'
alias mview='mvim -R -'

alias sst='svn status'
sd() { svn diff $* | e }
alias sca='svn commit'
alias scam='svn commit -m'

alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcam='git commit -v -a -m'
alias gb='git branch'
alias gba='git branch -a'
gbl() { git blame $* | view }
gd() { git diff $* | view }
gsl() { git stash list }
gss() { git stash show -p "stash@{$*}" | view }
gsd() { git stash drop "stash@{$*}" }
gsp() { git stash pop "stash@{$*}" }

alias migrate='rake db:migrate db:test:clone'
alias rst='touch tmp/restart.txt'
alias r='bundle exec rails'
alias bcuc='bundle exec rake cucumber LOG=no'
alias bspec='bundle exec rake spec LOG=no'
alias rcov='rake rcov LOG=no'
alias cuc='bundle exec cucumber -r features'
alias spe='bundle exec rspec'
alias fetch='curl -C - -O'
alias %=' '

if [[ -n $VIMRUNTIME ]]; then
  export PS1=$'%3~$ '
else
  export PS1=$'%{\e]0;%n@%m\a%}%{\e[0;32m%}%3~$%{\e[0m%} '
fi

export TERM=xterm-256color
export EDITOR='e -w'
export CLICOLOR='1'
export LSCOLORS='exfxcxdxbxexexexexexhx' # BSD ls
export LC_CTYPE=en_US.UTF-8

HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=1000
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

function this() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

function q-history-search-backward() {
  if [[ ( $LASTWIDGET != 'q-history-search-backward' ) && ( $LASTWIDGET != 'q-history-search-forward' ) ]]; then
    HIST_CURSOR=$CURSOR
  else
    CURSOR=$HIST_CURSOR
  fi
  zle .history-beginning-search-backward
  zle .end-of-line
}

function q-history-search-forward() {
  if [[ ( $LASTWIDGET != 'q-history-search-backward' ) && ( $LASTWIDGET != 'q-history-search-forward' ) ]]; then
    HIST_CURSOR=$CURSOR
  else
    CURSOR=$HIST_CURSOR
  fi
  zle .history-beginning-search-forward
  zle .end-of-line
}

zle -N q-history-search-backward
zle -N q-history-search-forward

bindkey '\e[A' q-history-search-backward
bindkey '\e[B' q-history-search-forward
bindkey '\e[1;5C' forward-word
bindkey '\e[1;5D' backward-word
bindkey '\eOC' forward-word
bindkey '\eOD' backward-word
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[3~' delete-char
bindkey "\e[9~" backward-delete-word
