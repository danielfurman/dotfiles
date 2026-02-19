#!/usr/bin/env bash
# Install or save VS Code extensions list.

usage() {
    echo -e "Usage: $(basename "$0") [options]\n"
    echo -e "Install or save VS Code extensions list.\n"
    echo "Options:"
    echo -e "\t(no flags)       => Install extensions from file"
    echo -e "\t--save           => Save installed extensions to file (instead of installing)"
    echo -e "\t--help (-h)      => Show usage"
}

if [ $# -eq 0 ]; then
    install=1
fi

while [ $# -gt 0 ]; do
    case "$1" in
        --save) save=1;;
        -h | --help) usage; exit 0;;
        *) usage; exit 1;;
    esac
    shift
done

run() {
    [ -n "$install" ] && install_vscode_extensions
    [ -n "$save" ] && save_vscode_extensions
}

install_vscode_extensions() {
    # shellcheck disable=SC2002
    cat files/vscode/vscode-ext.txt | xargs -n 1 code --install-extension
}

save_vscode_extensions() {
    code --list-extensions > files/vscode/vscode-ext.txt
}

run
