#!/usr/bin/env bash

run() {
    sed -i'.bak' \
        -e 's/foo/duck/g' \
        -e 's/bar/duck/g' \
        "file/path"
}

run
