#!/usr/bin/env sh

if [ -d "${HOME}/bin" ]; then
    PATH="${HOME}/bin:${PATH}"
fi

PATH="${PATH}:${HOME}/bin:${HOME}/scripts:/usr/local/go/bin"

export GOPATH="${HOME}/projects/gopath"
PATH="${PATH}:$(go env GOPATH)/bin"
export PATH

export EDITOR=vim
export GIT_TERMINAL_PROMPT=1
export LESS=-iR

# export HISTFILESIZE= # Eternal bash history: http://stackoverflow.com/questions/9457233/unlimited-bash-history
# export HISTSIZE=
# export PROMPT_COMMAND="history -a; $PROMPT_COMMAND" # Force prompt to write history after every command: http://superuser.com/questions/20900/bash-history-loss
