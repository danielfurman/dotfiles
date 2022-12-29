#!/usr/bin/env bash

run() {
	pushd "$HOME/projects/go" || return 1
	update-child-repos.sh
	popd || return 1

	pushd "$HOME/projects/python" || return 1
	update-child-repos.sh
	popd || return 1
}

run
