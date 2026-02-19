#!/usr/bin/env bash
# Symlink dotfiles.

# Colors
NO_COLOR='\033[0m'
GREEN='\033[0;32m'

usage() {
    echo -e "Usage: $(basename "$0") [options]\n"
    echo -e "Symlink dotfiles.\n"
    echo "Options:"
    echo -e "\t-f, --force	=> Force symlink create"
    echo -e "\t-h, --help	=> Show usage"
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

while :; do
    case "$1" in
        -f | --force) force_symlink=1; shift;;
        -h | --help) usage; exit 0;;
        *) break;;
    esac
done

run() {
    # shellcheck disable=SC2034
    declare -r files_path=$PWD/files # symlinks require full paths

    LN="ln -sv"
    [ -n "$force_symlink" ] && LN="ln -sfv"

    mkdir -p "${HOME}/.ssh" "${HOME}/.config/git"

    ${LN} "$files_path/shell/.bash_profile" "${HOME}/.bash_profile"
    ${LN} "$files_path/shell/.zprofile" "${HOME}/.zprofile"
    ${LN} "$files_path/shell/.profile" "${HOME}/.profile"
    ${LN} "$files_path/shell/.zshrc" "${HOME}/.zshrc"

    ${LN} "$files_path/git/config" "${HOME}/.config/git/config"
    ${LN} "$files_path/git/ignore" "${HOME}/.config/git/ignore"
    cp -n "$files_path/git/config_local" "${HOME}/.config/git/config_local"
    colored_echo "Adjust local git config if needed: ~/.config/git/config_local" "$GREEN"

    if [ -n "$force_symlink" ]; then
        rm -r "${HOME}/.config/github-copilot/intellij"
    fi
    ${LN} "$files_path/github-copilot/intellij" "${HOME}/.config/github-copilot/"
    ${LN} "$files_path/helix/config.toml" "${HOME}/.config/helix/config.toml"
    ${LN} "$files_path/tmux/.tmux.conf" "${HOME}/.tmux.conf"
    ${LN} "$files_path/scripts" "${HOME}/"

    if [ "$(uname)" == 'Darwin' ]; then
        ${LN} "$files_path/ssh/config-mac" "${HOME}/.ssh/config"
        ${LN} "$files_path/vscode/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"
        ${LN} "$files_path/vscode/settings.json" "${HOME}/Library/Application Support/Cursor/User/settings.json"
        ${LN} "$files_path/vscode/keybindings.json" "${HOME}/Library/Application Support/Code/User/keybindings.json"
        ${LN} "$files_path/vscode/keybindings.json" "${HOME}/Library/Application Support/Cursor/User/keybindings.json"
        ${LN} "$files_path/vscode/mcp.json" "${HOME}/Library/Application Support/Code/User/mcp.json"
        if [ -n "$force_symlink" ]; then
            rm -r "${HOME}/Library/Application Support/Code/User/prompts"
        fi
        ${LN} "$files_path/vscode/prompts" "${HOME}/Library/Application Support/Code/User"

        ${LN} "$files_path/mac/hammerspoon" "${HOME}/.hammerspoon"
        ${LN} "$files_path/mac/linearmouse.json" "${HOME}/.config/linearmouse/linearmouse.json"
        ${LN} "$files_path/mac/karabiner.json" "${HOME}/.config/karabiner/karabiner.json"
    else
        ${LN} "$files_path/ssh/config-linux" "${HOME}/.ssh/config"
        ${LN} "$files_path/vscode/settings.json" "${HOME}/.config/Code - OSS/User/settings.json"
        ${LN} "$files_path/vscode/settings.json" "${HOME}/.config/Cursor/User/settings.json"
        ${LN} "$files_path/vscode/keybindings.json" "${HOME}/.config/Code - OSS/User/keybindings.json"
        ${LN} "$files_path/vscode/keybindings.json" "${HOME}/.config/Cursor/User/keybindings.json"
    fi
}

colored_echo() {
    echo -e "${2}${1}${NO_COLOR}"
}

run
