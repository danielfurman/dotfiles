#!/usr/bin/env bash
# Put uncommented code in ~/.bash_profile:
# if [ -r ~/.profile ]; then source ~/.profile; fi
# case "$-" in *i*) if [ -r ~/.bashrc ]; then source ~/.bashrc; fi;; esac
#
# Put uncommented code in ~/.profile:
# if [ -r ~/.profile_custom.sh ]; then source ~/.profile_custom.sh; fi

export EDITOR=/usr/bin/vim
export ETCDCTL_API=3
export GOPATH=$HOME/projects/gopath
export HISTFILESIZE= # Eternal bash history: http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTSIZE=
export PATH=$PATH:~/bin:/usr/local/go/bin:$GOPATH/bin
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND" # Force prompt to write history after every command: http://superuser.com/questions/20900/bash-history-loss

# Virtualenv support
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=~/.virtualenvs
export PROJECT_HOME=~/projects
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
  source /usr/local/bin/virtualenvwrapper.sh
fi
