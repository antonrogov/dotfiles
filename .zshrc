# .zshrc

alias h='history 25'
alias j='jobs -l'
alias la='ls -a'
alias ll='ls -lA'
alias ff='find . -name'
alias view='vim -R -'

alias sst='svn status'
sd() { svn diff $* | e }
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
gbl() { git blame $* | view }
gd() { git diff $* | view }
gdc() { git diff --cached $* | view }
gsl() { git stash list }
gss() { git stash show -p "stash@{$*}" | view }
gsd() { git stash drop "stash@{$*}" }
gsp() { git stash pop "stash@{$*}" }
glr() { pretty_git_log --all -30 $* }
gla() { pretty_git_log --all $* }

alias reload!='. ~/.zshrc'
alias fetch='curl -C - -O'
alias ensure '(echo "while(1)" ; echo "\!* && break" ; echo end) | csh -f'
alias q3='/Applications/Quake3/Quake3.app/Contents/MacOS/Quake3\ UB +set fs_game osp +exec ~/Library/Application\ Support/Quake3/osp/q3config.cfg'
alias pgstart='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pgstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias deploying="git log --pretty=oneline live..master | grep fixes | sed -E 's/.*(#[0-9]+).*/\1/' | sort | tr '\n' ' ';echo"

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
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[3~' delete-char
bindkey "\e[9~" backward-delete-word

function devise-slim() {
  rails generate devise:views -e erb
  for i in `find app/views/devise -name '*.erb'` ; do html2haml -e $i ${i%erb}haml ; rm $i ; done
  for i in `find app/views/devise -name '*.haml'` ; do haml2slim $i ${i%haml}slim ; rm $i ; done
}



# Log output:
#
# * 51c333e    (12 days)    <Gary Bernhardt>   add vim-eunuch
#
# The time massaging regexes start with ^[^<]* because that ensures that they
# only operate before the first "<". That "<" will be the beginning of the
# author name, ensuring that we don't destroy anything in the commit message
# that looks like time.
#
# The log format uses } characters between each field, and `column` is later
# used to split on them. A } in the commit subject or any other field will
# break this.

function pretty_git_log() {
  HASH="%C(yellow)%h%Creset"
  RELATIVE_TIME="%Cgreen(%ar)%Creset"
  AUTHOR="%C(bold blue)<%an>%Creset"
  REFS="%C(red)%d%Creset"
  SUBJECT="%s"

  FORMAT="$HASH}$RELATIVE_TIME}$AUTHOR}$REFS $SUBJECT"

  git log --graph --pretty="tformat:${FORMAT}" $* |
    # Replace (2 years ago) with (2 years)
    sed -Ee 's/(^[^<]*) ago)/\1)/' |
    # Replace (2 years, 5 months) with (2 years)
    sed -Ee 's/(^[^<]*), [[:digit:]]+ .*months?)/\1)/' |
    # Line columns up based on } delimiter
    column -s '}' -t |
    # Page only if we need to
    less -FXRS
}

# use AppleScript to communicate with the Pomodoro application on OSX
function pomodoro() {
  case $1 in
    start)
      osascript -e "tell app \"Pomodoro\" to start \"$2\" duration 25 break 5"
      ;;
    stop)
      osascript -e "tell app \"Pomodoro\" to reset"
      ;;
    pause)
      osascript -e "tell app \"Pomodoro\" to external interrupt"
      ;;
    resume)
      osascript -e "tell app \"Pomodoro\" to resume"
      ;;
    list)
      osascript ~/Library/Scripts/today.scpt
      ;;
    stats)
      osascript ~/Library/Scripts/stats.scpt $2 $3 | sort
      ;;
    *)
      echo "${0} start {task desc}|stop|pause|resume|list|stats {area name} [more]"
  esac
}
