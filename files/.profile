#!/usr/bin/env sh

export GOPATH="${HOME}/projects/gopath"

PATH="${PATH}:${HOME}/.local/bin"
PATH="${PATH}:/usr/local/go/bin"
PATH="${PATH}:${GOPATH}/bin"
PATH="${PATH}:${HOME}/scripts"

# export QT_QPA_PLATFORMTHEME="gnome" # for Manjaro
