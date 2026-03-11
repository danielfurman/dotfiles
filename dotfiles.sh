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

    mkdir -p "${HOME}/.ssh" "${HOME}/.config/git" "${HOME}/.copilot"

    ${LN} "$files_path/shell/.bash_profile" "${HOME}/.bash_profile"
    ${LN} "$files_path/shell/.zprofile" "${HOME}/.zprofile"
    ${LN} "$files_path/shell/.profile" "${HOME}/.profile"
    ${LN} "$files_path/shell/.zshrc" "${HOME}/.zshrc"

    ${LN} "$files_path/git/config" "${HOME}/.config/git/config"
    ${LN} "$files_path/git/ignore" "${HOME}/.config/git/ignore"
    cp -n "$files_path/git/config_local" "${HOME}/.config/git/config_local"
    colored_echo "Adjust local git config if needed: ~/.config/git/config_local" "$GREEN"

    symlink_dir "$files_path/agents" "${HOME}/.agents"
    symlink_dir "$files_path/copilot/intellij" "${HOME}/.config/github-copilot/intellij"
    ${LN} "$files_path/copilot/mcp-config.json" "${HOME}/.copilot/mcp-config.json"
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

        symlink_dir "$files_path/mac/hammerspoon" "${HOME}/.hammerspoon"
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

symlink_dir() {
    declare -r source_path="$1"
    declare -r target_path="$2"

    if [ -n "$force_symlink" ]; then
        rm -rf "$target_path"
        ln -sv "$source_path" "$target_path"
        return
    fi

    # Avoid nested links when target already exists as a directory.
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        colored_echo "Skip existing path: $target_path" "$GREEN"
        return
    fi

    ln -sv "$source_path" "$target_path"
}

colored_echo() {
    echo -e "${2}${1}${NO_COLOR}"
}

run
