#!/usr/bin/env bash

function run {
	cd "$HOME/projects/juniper" || return 1
	update-child-repos.sh

	cd "$HOME/projects/gopath/src/github.com/Juniper" || return 1
	update-child-repos.sh

	cd "$HOME/projects/go" || return 1
	update-child-repos.sh
}

run || exit 1
