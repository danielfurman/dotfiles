#!/usr/bin/env sh

export GOPATH="${HOME}/gopath"

PATH="${PATH}:${HOME}/.local/bin"
PATH="${PATH}:/usr/local/opt/python/libexec/bin" # Python installed via Brew
PATH="${PATH}:/usr/local/go/bin" # Go on Linux
PATH="${PATH}:${GOPATH}/bin"
PATH="${PATH}:${HOME}/scripts"

PATH="${PATH}:/usr/local/opt/go@1.19/bin"

# export QT_QPA_PLATFORMTHEME="gnome" # for Manjaro
