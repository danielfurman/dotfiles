#!/usr/bin/env bash

# Aliases
alias ccat='pygmentize -g'
alias dcps='docker-compose ps'
alias docker-ip='docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias docker-rm-exited='docker rm $(docker ps -aq -f status=exited); docker volume rm $(docker volume ls -qf dangling=true)'
alias dps='docker ps -a'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch --prune --all'
alias gs='git status'
alias gss='git status --short'
alias prettyjson='python -m json.tool | ccat'
alias timestamp='date +%F-%H-%M-%S'
alias youtube-dl-360='youtube-dl  -f "bestvideo[height <= 360]+bestaudio"'
alias youtube-dl-480='youtube-dl  -f "bestvideo[height <= 480]+bestaudio"'
alias youtube-dl-720='youtube-dl  -f "bestvideo[height <= 720]+bestaudio"'
alias youtube-dl-1080='youtube-dl  -f "bestvideo[height <= 1080]+bestaudio"'

# Aliases for opt applications
alias et32='cd ~/opt/etlegacy-v2.76-i386 && ./etl'
alias et64='cd ~/opt/etlegacy-v2.76-x86_64 && ./etl'
alias etserver32='cd ~/opt/etlegacy-v2.76-i386 && ./etlded +dedicated 1 +exec etl_server.cfg'
alias etserver64='cd ~/opt/etlegacy-v2.76-x86_64 && ./etlded +dedicated 1 +exec etl_server.cfg'

if [ -r "/usr/share/doc/pkgfile/command-not-found.bash" ]; then
    # shellcheck disable=SC1091
    source "/usr/share/doc/pkgfile/command-not-found.bash"
fi

# Virtualenv support
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME="${HOME}/.virtualenvs"
export PROJECT_HOME="${HOME}/projects"
if [ -r "/usr/local/bin/virtualenvwrapper.sh" ]; then
    # shellcheck disable=SC1091
    source "/usr/local/bin/virtualenvwrapper.sh"
fi

if [ -n "${BASH_VERSION}" ]; then
    if [ -r "${HOME}/.iterm2_shell_integration.bash" ]; then
        # shellcheck disable=SC1090
        source "${HOME}/.iterm2_shell_integration.bash"
    fi

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
    # shellcheck disable=SC1090,SC2034
    {
        COMPLETION_WAITING_DOTS="true"
        DISABLE_CORRECTION="true"
        HYPHEN_INSENSITIVE="true"
        plugins=(docker docker-compose git)
        export ZSH="${HOME}/.oh-my-zsh"
        ZSH_THEME="robbyrussell"

        source "${ZSH}/oh-my-zsh.sh"

        if [ -r "${HOME}/.iterm2_shell_integration.zsh" ]; then
            source "${HOME}/.iterm2_shell_integration.zsh"
        fi
    }
fi

gocov() {
    local t
    t=$(mktemp -t gocovXXXXXXXXXXXXXXXX)
    go test -coverprofile="$t" "$@"
    go tool cover -func="$t"
    unlink "$t"
}

gocov-html() {
    local t
    t=$(mktemp -t gocovXXXXXXXXXXXXXXXX)
    go test -coverprofile="$t" -covermode=count "$@"
    go tool cover -html="$t"
    unlink "$t"
}

extract() {
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

purge-old-kernels-on-ubuntu() {
    echo \
        "$(dpkg --list | grep linux-image | awk '{ print $2 }' | sort -V | sed -n '/'"$(uname -r)"'/q;p')" \
        "$(dpkg --list | grep linux-headers | awk '{ print $2 }' | sort -V | sed -n '/'"$(uname -r | sed "s/\([0-9.-]*\)-\([^0-9]\+\)/\1/")"'/q;p')" | \
        xargs sudo apt-get -y purge
}
