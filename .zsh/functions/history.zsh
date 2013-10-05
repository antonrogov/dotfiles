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
