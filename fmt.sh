#!/bin/sh

jq --sort-keys '.' files/vscode/settings.json > files/vscode/settings.json2
mv files/vscode/settings.json2 files/vscode/settings.json
