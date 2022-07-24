#!/usr/bin/env sh

export GOPATH="${HOME}/projects/gopath"

PATH="${PATH}:${HOME}/scripts"
PATH="${PATH}:/usr/local/go/bin"
PATH="${PATH}:$(go env GOPATH)/bin"
export PATH

export EDITOR=vim
export GIT_TERMINAL_PROMPT=1
export PAGER="less -FX"
