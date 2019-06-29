#!/usr/bin/env bash
# Put uncommented code in ~/.profile:
# if [ -f ~/.profile_custom.sh ]; then
#   source ~/.profile_custom.sh
# fi

export GOPATH=$HOME/projects/gopath
PATH=$PATH:/usr/local/go/bin:$GOPATH/bin # Extend PATH with Go binaries
