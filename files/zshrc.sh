#!/usr/bin/env zsh
# shellcheck disable=SC1090,SC1091,SC2034

# Setup Oh My ZSH

COMPLETION_WAITING_DOTS="true"
DISABLE_CORRECTION="true"
HYPHEN_INSENSITIVE="true"
ZSH_THEME="robbyrussell"
ZSH="${HOME}/.oh-my-zsh"

plugins=(docker docker-compose git)

source "${ZSH}/oh-my-zsh.sh"

# Setup command completion

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit # for Bash completion in ZSH

if [ -r "/usr/share/doc/pkgfile/command-not-found.bash" ]; then
    source "/usr/share/doc/pkgfile/command-not-found.bash"
fi

if [ -r "${HOME}/.iterm2_shell_integration.zsh" ]; then
    source "${HOME}/.iterm2_shell_integration.zsh"
fi

if golangci-lint --version > /dev/null 2>&1; then
    source <(golangci-lint completion zsh)
fi

if kubectl version --client > /dev/null 2>&1; then
    source <(kubectl completion zsh)
fi

complete -o nospace -C /usr/bin/aws_completer aws
complete -o nospace -C "$(which gocomplete)" go
complete -o nospace -C /usr/bin/terraform terraform

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
alias timestamp='date +%F-%H-%M-%S'

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

function purge-old-kernels-on-ubuntu() {
    echo \
        "$(dpkg --list | grep linux-image | awk '{ print $2 }' | sort -V | sed -n '/'"$(uname -r)"'/q;p')" \
        "$(dpkg --list | grep linux-headers | awk '{ print $2 }' | sort -V | sed -n '/'"$(uname -r | sed "s/\([0-9.-]*\)-\([^0-9]\+\)/\1/")"'/q;p')" | \
        xargs sudo apt-get -y purge
}
