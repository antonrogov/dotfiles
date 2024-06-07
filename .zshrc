# .zshrc

export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

typeset -gU path fpath

path=(
  $HOME/bin(N)
  $HOME/.cargo/bin(N)
  /opt/homebrew/opt/imagemagick@6/bin(N)
  /opt/homebrew/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $path
)

fpath=(~/.zsh/functions $fpath)
autoload -Uz $fpath[1]/*(.:t)

alias h='history 25'
alias j='jobs -l'
alias la='ls -a'
alias ll='ls -lA'
alias ff='find . -name'
alias view='vim -R'
alias v='view -'
alias vg="view -c 'set filetype=git nowrap' -"
alias fetch='curl -L -C - -O'
bgrep() { grep -R "${@:1:-1}" $(bundle show ${@: -1}) }

export EDITOR='vim'
export CLICOLOR='1'
export LSCOLORS='exfxcxdxbxexexexexAxAx'
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export ACK_COLOR_MATCH='red'
export GREP_OPTIONS='--color'
set -o emacs

HISTFILE=~/.history
HISTSIZE=100000
SAVEHIST=$HISTSIZE
REPORTTIME=10 # print elapsed time when more than 10 seconds
WORDCHARS='*?[]~&;!$%^<>'

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
setopt PROMPT_SUBST

escape() { echo "%{\e[0${1}m%}" }
color() { escape ";3${1}" }
black() { color 0 }
red() { color 1 }
green() { color 2 }
separator() { repeat $COLUMNS printf -- - ; end }
remove_separator() { export PROMPT="$(red)%m:%3~$ $(escape)" }

if [[ -n $SSH_CONNECTION ]]; then
  export PROMPT="$(black)\$(separator)$(red)%m:%3~$ $(escape)"
else
  if [[ -n $VIMRUNTIME ]]; then
    export PROMPT="%3~$ "
  else
    export PROMPT="$(green)%3~$ $(escape)"
  fi
fi

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

bindkey '^p' q-history-search-backward
bindkey '^n' q-history-search-forward

autoload -U compinit
compinit

autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# By default, ^S freezes terminal output and ^Q resumes it. Disable that so
# that those keys can be used for other things.
unsetopt flowcontrol

[[ -s ~/.zshrc.local ]] && . ~/.zshrc.local
