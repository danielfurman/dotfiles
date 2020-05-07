#!/usr/bin/env bash

run() {
	local fileNamePattern="*_i_test.go"
	local srcPattern="i_test.go"
	local dstPattern="integration_test.go"

	files=$(find . -name "${fileNamePattern}")

	for file in ${files}
	do
		mv -iv "${file}" "${file/${srcPattern}/${dstPattern}}"
	done
}

run
