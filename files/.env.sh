#!/usr/bin/env sh

if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi

export PATH=$PATH:~/bin:~/scripts:/usr/local/go/bin

export GOPATH=$HOME/projects/gopath
export PATH=$PATH:$(go env GOPATH)/bin

export EDITOR=vim
export GIT_TERMINAL_PROMPT=1

# export HISTFILESIZE= # Eternal bash history: http://stackoverflow.com/questions/9457233/unlimited-bash-history
# export HISTSIZE=
# export PROMPT_COMMAND="history -a; $PROMPT_COMMAND" # Force prompt to write history after every command: http://superuser.com/questions/20900/bash-history-loss
