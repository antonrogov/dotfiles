# .zshrc

alias h='history 25'
alias j='jobs -l'
alias l='ls -lA --color'
brg() { rg "${@:2}" $(bundle show $1) }

# export EDITOR=${EDITOR:-v}
export EDITOR=v
# export CLICOLOR=1
export LSCOLORS=exfxcxdxbxexexexexAxAx
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
# export ACK_COLOR_MATCH=red
# export GREP_OPTIONS=--color
set -o emacs

HISTFILE=${ZDOTDIR:-$HOME}/.history
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
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt COMPLETE_IN_WORD
setopt PROMPT_SUBST
unsetopt flowcontrol

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

_prompt_executing=""
function __prompt_precmd() {
    local ret="$?"
    if test "$_prompt_executing" != "0"
    then
      _PROMPT_SAVE_PS1="$PS1"
      _PROMPT_SAVE_PS2="$PS2"
      PS1=$'%{\e]133;P;k=i\a%}'$PS1$'%{\e]133;B\a\e]122;> \a%}'
      PS2=$'%{\e]133;P;k=s\a%}'$PS2$'%{\e]133;B\a%}'
    fi
    if test "$_prompt_executing" != ""
    then
       printf "\033]133;D;%s;aid=%s\007" "$ret" "$$"
    fi
    printf "\033]133;A;cl=m;aid=%s\007" "$$"
    _prompt_executing=0
}
function __prompt_preexec() {
    PS1="$_PROMPT_SAVE_PS1"
    PS2="$_PROMPT_SAVE_PS2"
    printf "\033]133;C;\007"
    _prompt_executing=1
}
preexec_functions+=(__prompt_preexec)
precmd_functions+=(__prompt_precmd)

ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(send-break)

HISTORY_SUBSTRING_SEARCH_PREFIXED=1
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=179'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=9'
source $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down

[[ -s ~/.zshrc.local ]] && . ~/.zshrc.local
