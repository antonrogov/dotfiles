# .zshrc

PATH="$HOME/bin:$PATH"
PATH="$HOME/.rbenv/shims:$PATH"
PATH="node_modules/.bin:$PATH"
export PATH

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
alias gpu='git push --set-upstream'
alias gpb='git push --set-upstream origin `this`'
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
alias fetch='curl -L -C - -O'

export EDITOR='vim'
export CLICOLOR='1'
export LSCOLORS='exfxcxdxbxexexexexexhx'
export LC_CTYPE=en_US.UTF-8
export ACK_COLOR_MATCH='red'
export GREP_OPTIONS='--color'
export HOMEBREW_CASK_OPTS='--appdir=/Applications --caskroom=/usr/local/Caskroom'
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
green() { color 2 }
separator() { repeat $COLUMNS printf '-' ; end }

if [[ -n $SSH_CONNECTION ]]; then
  export PROMPT="$(black)\$(separator)$(red)%m:%3~$ $(escape)"
else
  if [[ -n $VIMRUNTIME ]]; then
    export PROMPT="%3~$ "
  else
    export PROMPT="$(black)\$(separator)$(green)%3~$ $(escape)"
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

[[ -s ~/.zshrc.local ]] && . ~/.zshrc.local
