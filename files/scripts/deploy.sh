#!/bin/bash

ticket="PDT-9154"
namespace="oos"
service="tickets-command-processor"
env="dev"
env_full="development"
tag="v0.0.59"
major_version="v0"

function main() {
	values_path="$env_full/$namespace/$service/$major_version/values.yaml"
	echo "Deploying $service to $env with tag $tag using $values_path"

	git fetch
	git checkout -b "$ticket-$service-$tag/$env" origin/master --no-track
	sed -i "" "s/^\([[:space:]]*tag:[[:space:]]*\)v[0-9.\-]*/\1$tag/" "$values_path"
	git add -u
	git commit -m "[$ticket][$service][$env] Deploy $tag"
	git push

	gh pr create -f --dry-run
	git checkout master
}

main "$@"
