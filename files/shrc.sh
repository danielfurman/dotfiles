#!/usr/bin/env bash

if [ -n "${BASH_VERSION}" ]; then
    # shellcheck disable=SC1090,SC1091
    {
        if [ -r "${HOME}/.iterm2_shell_integration.bash" ]; then
            source "${HOME}/.iterm2_shell_integration.bash"
        fi

        if golangci-lint --version > /dev/null 2>&1; then
            source <(golangci-lint completion bash)
        fi

        if kubectl version --client > /dev/null 2>&1; then
            source <(kubectl completion bash)
        fi
    }

    # Custom command prompt
    RESET="\[\017\]"
    NORMAL="\[\033[0m\]"
    YELLOW="\[\033[33;1m\]"
    RED="\[\033[31;1m\]"
    SMILEY="${YELLOW}:)${NORMAL}"
    FROWNY="${RED}:(${NORMAL}"
    SELECT="if [ \$? = 0 ]; then echo \"${SMILEY}\"; else echo \"${FROWNY}\"; fi"
    PS1="${RESET}${YELLOW}\u${NORMAL}@${NORMAL}\h${NORMAL}\`${SELECT}\`\w${YELLOW}> ${NORMAL}"
fi

if [ -n "${ZSH_VERSION}" ]; then
    # shellcheck disable=SC1090,SC1091,SC2034
    {
        COMPLETION_WAITING_DOTS="true"
        DISABLE_CORRECTION="true"
        HYPHEN_INSENSITIVE="true"
        plugins=(docker docker-compose git)
        export ZSH="${HOME}/.oh-my-zsh"
        ZSH_THEME="robbyrussell"

        source "${ZSH}/oh-my-zsh.sh"

        autoload -U +X compinit && compinit
        autoload -U +X bashcompinit && bashcompinit # for Bash completion in ZSH

        if [ -r "${HOME}/.iterm2_shell_integration.zsh" ]; then
            source "${HOME}/.iterm2_shell_integration.zsh"
        fi

        if golangci-lint --version > /dev/null 2>&1; then
            source <(golangci-lint completion zsh)
        fi

        if kubectl version --client > /dev/null 2>&1; then
            source <(kubectl completion zsh)
        fi
    }
fi

# Bash completion also for ZSH
complete -o nospace -C /usr/bin/aws_completer aws
complete -o nospace -C "$(which gocomplete)" go
complete -o nospace -C /usr/bin/terraform terraform

if [ -r "/usr/share/doc/pkgfile/command-not-found.bash" ]; then
    # shellcheck disable=SC1091
    source "/usr/share/doc/pkgfile/command-not-found.bash"
fi

# Virtualenv support
# shellcheck disable=SC1091
{
    export WORKON_HOME="${HOME}/.virtualenvs"
    export PROJECT_HOME="${HOME}/projects"

    if [ -r "/usr/local/bin/virtualenvwrapper.sh" ]; then
        source "/usr/local/bin/virtualenvwrapper.sh"
    fi

    if [ -r "/usr/bin/virtualenvwrapper.sh" ]; then
        source "/usr/bin/virtualenvwrapper.sh"
    fi
}

# Aliases. Need to be defined after sourcing Oh My ZSH to override its aliases.
alias dcps='docker-compose ps'
alias dps='docker ps -a'
alias timestamp='date +%F-%H-%M-%S'

# Aliases for opt applications
alias et32='cd ~/opt/etlegacy-v2.76-i386 && ./etl'
alias et64='cd ~/opt/etlegacy-v2.76-x86_64 && ./etl'
alias etserver32='cd ~/opt/etlegacy-v2.76-i386 && ./etlded +dedicated 1 +exec etl_server.cfg'
alias etserver64='cd ~/opt/etlegacy-v2.76-x86_64 && ./etlded +dedicated 1 +exec etl_server.cfg'

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
