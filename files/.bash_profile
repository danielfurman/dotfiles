#!/usr/bin/env bash

# shellcheck disable=SC1091
if [ -r "${HOME}/.profile" ]; then source "${HOME}/.profile"; fi
case "$-" in *i*) if [ -r "${HOME}/.bashrc" ]; then source "${HOME}/.bashrc"; fi;; esac
