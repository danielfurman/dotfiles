#!/usr/bin/env bash
# Script fetches and rebases git repositories cloned to current directory.

function run {
  find . -mindepth 2 -maxdepth 2 -type d -name '.git' -print -exec git -C {}/.. fetch --prune \; \
  	\( -exec git -C {}/.. rebase \; -o -exec true \; \) -exec echo \;
}

run
