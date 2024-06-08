#!/bin/zsh

fpath=($ZDOTDIR/functions $fpath)
autoload -Uz $fpath[1]/*(.:t)
