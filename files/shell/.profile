#!/usr/bin/env sh

export GOPATH="${HOME}/gopath"

PATH="/usr/local/opt/gnu-sed/libexec/gnubin:${PATH}" # Use GNU sed on macOS by default

PATH="${PATH}:${HOME}/.local/bin"
PATH="${PATH}:/usr/local/go/bin" # Go on Linux
PATH="${PATH}:${GOPATH}/bin"
PATH="${PATH}:${HOME}/.cargo/bin"
PATH="${PATH}:/opt/homebrew/opt/python/libexec/bin" # Python binaries installed via Brew
PATH="${PATH}:${HOME}/scripts"

PATH="${PATH}:${HOME}/Library/Application Support/JetBrains/Toolbox/scripts"
PATH="${PATH}:${HOME}/.lmstudio/bin"
PATH="${PATH}:${HOME}/projects/poe/team/customer-integration/shared/scripts/bash"

eval "$(/opt/homebrew/bin/brew shellenv)"
