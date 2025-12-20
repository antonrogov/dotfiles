#!/bin/zsh

export HOMEBREW_PREFIX=/opt/homebrew
export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}"

export BUNDLE_USER_HOME=$XDG_DATA_HOME/bundle
export BUNDLE_USER_CACHE=$XDG_CACHE_HOME/bundle
export BUNDLE_USER_CONFIG=$XDG_CONFIG_HOME/bundle/config
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/config
export NPM_CONFIG_CACHE=$XDG_CACHE_HOME/npm
export CARGO_HOME=$XDG_DATA_HOME/cargo
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export CODEX_HOME=$XDG_DATA_HOME/codex
export CLAUDE_CONFIG_DIR=$XDG_DATA_HOME/claude
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1

typeset -gU path fpath
path=(
  $HOME/bin(N)
  $CARGO_HOME/bin(N)
  $HOMEBREW_PREFIX/opt/imagemagick@6/bin(N)
  $HOMEBREW_PREFIX/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $path
)

fpath=($ZDOTDIR/functions $fpath)
autoload -Uz $fpath[1]/*(.:t)
