# .zshrc

export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

PATH="/usr/local/bin:$PATH"
PATH="/usr/local/opt/node@18/bin:$PATH"
PATH="/opt/homebrew/opt/imagemagick@6/bin:$PATH"
PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/bin:$PATH"
export PATH

alias h='history 25'
alias j='jobs -l'
alias la='ls -a'
alias ll='ls -lA'
alias ff='find . -name'
alias view='vim -R'
alias v='view -'
alias vg="view -c 'set filetype=git nowrap' -"
alias config='vim "~/iCloud/Config/"'

alias reload!='. ~/.zshrc'
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

bindkey '^p' q-history-search-backward
bindkey '^n' q-history-search-forward

autoload -U compinit
compinit

autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

for config_file ($HOME/.zsh/functions/*.zsh); do
  source $config_file
done

# By default, ^S freezes terminal output and ^Q resumes it. Disable that so
# that those keys can be used for other things.
unsetopt flowcontrol
# Run Selecta in the current working directory, appending the selected path, if
# any, to the current command.
function insert-selecta-path-in-command-line() {
    local selected_path
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    selected_path=$(find * -type f | selecta) || return
    # Append the selection to the current command buffer.
    eval 'LBUFFER="$LBUFFER$selected_path"'
    # Redraw the prompt since Selecta has drawn several new lines of text.
    zle reset-prompt
}
# Create the zle widget
zle -N insert-selecta-path-in-command-line
# Bind the key to the newly created widget
bindkey "^S" "insert-selecta-path-in-command-line"

# source /usr/local/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
# source /usr/local/opt/gem_home/share/gem_home/gem_home.sh
source /opt/homebrew/opt/gem_home/share/gem_home/gem_home.sh

[[ -s ~/.zshrc.local ]] && . ~/.zshrc.local
