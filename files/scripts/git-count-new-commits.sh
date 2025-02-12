#!/usr/bin/env bash
# Count commits made within last year in child repositories.

function run {
 	repositories=$(find . -mindepth 1 -maxdepth 5 -type d -name '.git')
	for r in ${repositories}
	do
		git -C "$r" glog --since '1 year ago' | wc -l | xargs echo "$r"
	done
}

run
