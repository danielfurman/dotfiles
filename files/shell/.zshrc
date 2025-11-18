#!/usr/bin/env zsh
# shellcheck disable=SC1090,SC1091,SC2034

## Setup env

export EDITOR=hx
export GIT_TERMINAL_PROMPT=1
export PAGER="less -Fi --tabs=4" # -F for quit if one screen; -i for case-insensitive search

## Setup command completion
# Completion scripts are installed to FPATH directories - manual sourcing should not be needed
fpath=(/Users/daniel/.docker/completions $fpath)
# autoload -Uz compinit && compinit         # already initialized by oh-my-zsh.sh
# autoload -Uz bashcompinit && bashcompinit # for Bash completion in ZSH; already initialized by oh-my-zsh.sh

## Setup Oh My ZSH

COMPLETION_WAITING_DOTS="true"
DISABLE_CORRECTION="true"
HYPHEN_INSENSITIVE="true"
ZSH_THEME="robbyrussell" # "cypher" has no git prompt
ZSH="${HOME}/.oh-my-zsh"

# ssh-agent for agent startup in WSL
plugins=(docker docker-compose git)
zstyle ':omz:update' mode auto  # update automatically without asking
source "${ZSH}/oh-my-zsh.sh"

## Setup fuzzy finding/selection
if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
    source <(fzf --zsh)
fi

## Setup Virtualenvwrapper
export WORKON_HOME="${HOME}/.virtualenvs"
export PROJECT_HOME="${HOME}/projects"
VIRTUALENVWRAPPER_PATH=$(which virtualenvwrapper.sh)
if [ -n "$VIRTUALENVWRAPPER_PATH" ]; then
    source "$VIRTUALENVWRAPPER_PATH"
fi

## Aliases. Need to be defined after sourcing Oh My ZSH to override its aliases.
alias dcps='docker-compose ps'
alias dps='docker ps -a'
alias venv='source .venv/bin/activate'
alias vim='nvim'

alias todev="aws sso login --profile developers && hash -r && export AWS_PROFILE=dev && export KUBECONFIG=~/.kube/dev-eks-90poe.config"
alias totest="aws sso login --profile developers && hash -r && export AWS_PROFILE=test && export KUBECONFIG=~/.kube/test-eks-90poe.config"
alias toint="aws sso login --profile developers && hash -r && export AWS_PROFILE=int && export KUBECONFIG=~/.kube/integration-eks-90poe.config"
alias toprod="aws sso login --profile developers && hash -r && export AWS_PROFILE=prod && export KUBECONFIG=~/.kube/prod-eks-90poe.config"


function tagpatch() {
    ../monorepo.sh tag add --project=$(go_project_name) --version=patch
}
function tagminor() {
    ../monorepo.sh tag add --project=$(go_project_name) --version=minor
}
function tagmajor() {
    ../monorepo.sh tag add --project=$(go_project_name) --version=major
}
function go_project_name() {
    local mod
    mod=$(go list -m)
    local last
    last=$(echo "$mod" | awk -F'/' '{print $NF}')
    if [[ $last =~ ^v[0-9]+$ ]]; then
        echo "$mod" | awk -F'/' '{print $(NF-1)}'
    else
        echo "$last"
    fi
}
alias tagpush="../monorepo.sh tag push"

## Utility functions

unalias gc
function gc() {
    local branches branch
    branches=$(git branch -vv) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

function gnew() {
    git checkout -b "$1" origin/master --no-track
}

function gdel() {
    git branch | rg -i "$1" | rg -v "(^\*|master)" | xargs git branch -D
}

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
