#!/usr/bin/env bash
# Script fetches and rebases git repositories cloned to given directories and nested.
# Usage: git-update-repos.sh /path/to/directory

run() {
	find "$@" -mindepth 1 -maxdepth 5 -type d -name '.git' -print \
		-exec git -C {}/.. fetch --all --prune --jobs 10 \; \
		\( -exec git -C {}/.. rebase \; -o -exec true \; \) \
		-exec echo \;
}

run "$@"
