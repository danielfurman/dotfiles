#!/usr/bin/env bash
# Script fetches and rebases git repositories cloned to given directories and nested.

run() {
	find "$@" -mindepth 2 -maxdepth 5 -type d -name '.git' -print \
		-exec git -C {}/.. fetch --all --prune --jobs 10 \; \
		\( -exec git -C {}/.. rebase \; -o -exec true \; \) \
		-exec echo \;
}

run "$@"
