#!/usr/bin/env bash
# Assume new AWS role specified in ~/.aws/config.
# Usage: assume-role.sh dev-test

function run {
    for i in $(env | grep AWS | cut -d '=' -f 1); do
        unset "$i";
    done

    # shellcheck disable=SC2046,SC2068
    eval $( $(which assume-role) -duration=12h $@);
}

run "$@"
