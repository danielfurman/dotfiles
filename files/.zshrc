#!/usr/bin/env zsh
# shellcheck disable=SC1090,SC1091,SC2034

# Setup env

export EDITOR=hx
export GIT_TERMINAL_PROMPT=1
export PAGER="less -Fi --tabs=4" # -F for quit if one screen; -i for case-insensitive search

# Setup Oh My ZSH

COMPLETION_WAITING_DOTS="true"
DISABLE_CORRECTION="true"
HYPHEN_INSENSITIVE="true"
ZSH_THEME="robbyrussell" # "cypher" has not git prompt
ZSH="${HOME}/.oh-my-zsh"

# ssh-agent for agent startup in WSL
plugins=(docker docker-compose git)
zstyle ':omz:update' mode auto  # update automatically without asking
source "${ZSH}/oh-my-zsh.sh"

# Setup command completion
# Completion scripts are installed to FPATH directories - manual sourcing should not be needed

# autoload -Uz compinit && compinit # already initialized by oh-my-zsh.sh
autoload -Uz bashcompinit && bashcompinit # for Bash completion in ZSH

# Not need - Brew installs awscli completions properly; Manjaro might not
# complete -C aws_completer aws

# Setup Virtualenvwrapper

export WORKON_HOME="${HOME}/.virtualenvs"
export PROJECT_HOME="${HOME}/projects"

if [ -r "/usr/local/bin/virtualenvwrapper.sh" ]; then
    source "/usr/local/bin/virtualenvwrapper.sh"
fi

if [ -r "/usr/bin/virtualenvwrapper.sh" ]; then
    source "/usr/bin/virtualenvwrapper.sh"
fi

# Aliases. Need to be defined after sourcing Oh My ZSH to override its aliases.

alias dcps='docker-compose ps'
alias dps='docker ps -a'
alias vim='nvim'

alias todev="hash -r && export KUBECONFIG=~/.kube/dev-eks-90poe.config"
alias totest="hash -r && export KUBECONFIG=~/.kube/test-eks-90poe.config"
alias tointegration="hash -r && export KUBECONFIG=~/.kube/integration-eks-90poe.config"
alias toprod="hash -r && export KUBECONFIG=~/.kube/prod-eks-90poe.config"

alias assume-role='function() {
    unset AWS_SECRET_ACCESS_KEY;
    unset AWS_SESSION_TOKEN;
    unset AWS_SECURITY_TOKEN;
    unset ASSUMED_ROLE;
    eval $(command assume-role -duration=12h $@);
}'

# Utility functions

function gocov-func() {
    local t
    t=$(mktemp -t gocovXXXXXXXXXXXXXXXX)
    go test -coverprofile="$t" "$@"
    go tool cover -func="$t"
    unlink "$t"
}

function gocov-html() {
    local t
    t=$(mktemp -t gocovXXXXXXXXXXXXXXXX)
    go test -coverprofile="$t" -covermode=count "$@"
    go tool cover -html="$t"
    unlink "$t"
}

function extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)  tar -jxvf "$1"                        ;;
            *.tar.gz)   tar -zxvf "$1"                        ;;
            *.bz2)      bunzip2 "$1"                          ;;
            *.dmg)      hdiutil mount "$1"                    ;;
            *.gz)       gunzip "$1"                           ;;
            *.tar)      tar -xvf "$1"                         ;;
            *.tbz2)     tar -jxvf "$1"                        ;;
            *.tgz)      tar -zxvf "$1"                        ;;
            *.zip)      unzip "$1"                            ;;
            *.ZIP)      unzip "$1"                            ;;
            *.pax)      pax -r -f "$1"                        ;;
            *.pax.Z)    uncompress "$1" --stdout | pax -r     ;;
            *.Z)        uncompress "$1"                       ;;
            *) echo "'$1' cannot be extracted/mounted via extract()" ;;
        esac
    else
         echo "'$1' is not a valid file to extract"
    fi
}

function purge-ubuntu-old-kernels() {
    echo \
        "$(dpkg --list | grep linux-image | awk '{ print $2 }' | sort -V | sed -n '/'"$(uname -r)"'/q;p')" \
        "$(dpkg --list | grep linux-headers | awk '{ print $2 }' | sort -V | sed -n '/'"$(uname -r | sed "s/\([0-9.-]*\)-\([^0-9]\+\)/\1/")"'/q;p')" | \
        xargs sudo apt-get -y purge
}
