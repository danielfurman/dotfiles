#!/usr/bin/env sh

export GOPATH="${HOME}/projects/gopath"

PATH="${PATH}:${HOME}/.local/bin"
PATH="${PATH}:/usr/local/opt/python/libexec/bin" # Python installed via Brew
PATH="${PATH}:/usr/local/go/bin" # Go on Linux
PATH="${PATH}:${GOPATH}/bin"
PATH="${PATH}:${HOME}/scripts"

# export QT_QPA_PLATFORMTHEME="gnome" # for Manjaro
