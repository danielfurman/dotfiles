#!/usr/bin/env bash
# Put uncommented code in ~/.bashrc:
# [[ -f ~/.bash_custom.sh ]] && source ~/.bash_custom.sh

# Aliases
alias ccat='pygmentize -g'
alias cdcontrail='cd $GOPATH/src/github.com/Juniper/contrail'
alias dcps='docker-compose ps'
alias docker-ip='docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias docker-rm-exited='docker rm $(docker ps -aq -f status=exited); docker volume rm $(docker volume ls -qf dangling=true)'
alias dps='docker ps -a'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch --prune --all'
alias gs='git status'
alias gss='git status --short'
alias gofix='go tool fix' # accepts package positional parameter, e.g. "gofix ./pkg"
alias gofix-diff='go tool fix --diff' # accepts package positional parameter, e.g. "gofix-diff ./pkg"
alias golnt='golangci-lint --enable-all -D=dupl -D=gosec --concurrency=1 --deadline=10m --exclude-use-default=false --max-issues-per-linter=0 --max-same-issues=0 run' # lacks more strict linters settings
alias golnt-metalinter='gometalinter --enable-all -D dupl -D gosec -D safesql -D test -D testify --concurrency 1 --deadline 5m --tests --vendor --aggregate --sort path line --line-length 120'
alias gotestloop='go test -count 1000000 -failfast'
alias gotestloopslow='go test -c -o ./t && i=1; while ./t; do i=$((i+1)); echo $i; done'
alias kill-keyboard='killall -9 ibus-x11'
alias l='ls -lh'
alias ll='ls -alh'
alias la='ls -A'
alias prettyjson='python -m json.tool | ccat'
alias timestamp='date +%F-%H-%M-%S'
alias youtube-dl-360='youtube-dl  -f "bestvideo[height <= 360]+bestaudio"'
alias youtube-dl-480='youtube-dl  -f "bestvideo[height <= 480]+bestaudio"'
alias youtube-dl-720='youtube-dl  -f "bestvideo[height <= 720]+bestaudio"'
alias youtube-dl-1080='youtube-dl  -f "bestvideo[height <= 1080]+bestaudio"'

# Aliases for opt applications
alias eagle='~/opt/eagle-8.0.1/eagle &'
alias et32='cd ~/opt/etlegacy-v2.76-i386 && ./etl'
alias et64='cd ~/opt/etlegacy-v2.76-x86_64 && ./etl'
alias etserver32='cd ~/opt/etlegacy-v2.76-i386 && ./etlded +dedicated 1 +exec etl_server.cfg'
alias etserver64='cd ~/opt/etlegacy-v2.76-x86_64 && ./etlded +dedicated 1 +exec etl_server.cfg'
alias postman='~/opt/Postman/Postman &'
alias swagger-codegen-cli='java -jar ~/opt/swagger-codegen-cli-2.2.3.jar'

# Custom command prompt
RESET="\[\017\]"
NORMAL="\[\033[0m\]"
YELLOW="\[\033[33;1m\]"
RED="\[\033[31;1m\]"
SMILEY="${YELLOW}:)${NORMAL}"
FROWNY="${RED}:(${NORMAL}"
SELECT="if [ \$? = 0 ]; then echo \"${SMILEY}\"; else echo \"${FROWNY}\"; fi"
PS1="${RESET}${YELLOW}\u${NORMAL}@${NORMAL}\h${NORMAL}\`${SELECT}\`\w${YELLOW}> ${NORMAL}"

# Command not found hook
if [ -r /usr/share/doc/pkgfile/command-not-found.bash ]; then source /usr/share/doc/pkgfile/command-not-found.bash; fi

# Go bash completion
complete -C "$(go env GOPATH)/bin/gocomplete" go

# Utility functions
function gocov() {
  local t
  t=$(mktemp -t gocovXXXXXXXXXXXXXXXX)
  go test -coverprofile="$t" "$@" && \
    go tool cover -func="$t" && \
    unlink "$t"
}

function gocov-html() {
  local t
  t=$(mktemp -t gocovXXXXXXXXXXXXXXXX)
  go test -coverprofile="$t" -covermode=count "$@" && \
    go tool cover -html="$t" && \
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
