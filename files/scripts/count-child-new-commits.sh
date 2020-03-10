#!/usr/bin/env bash
# Count new commits in child directories.

function run {
 	repositories=$(find . -mindepth 2 -maxdepth 2 -type d -name '.git')
	for r in ${repositories}
	do
		git -C ${r} glog --since '1 year ago' | wc -l | xargs echo ${r}
	done
}

run
