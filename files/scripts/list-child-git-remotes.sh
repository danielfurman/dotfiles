#!/usr/bin/env bash
# List URLs of git remotes in child directories.

function run {
 	repositories=$(find . -mindepth 2 -maxdepth 2 -type d -name '.git')
	for r in ${repositories}
	do
		git -C ${r} remote | xargs --max-args 1 --no-run-if-empty git -C ${r} remote get-url
	done
}

run
