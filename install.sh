#!/usr/bin/env bash
# Install and configure development tools.
# Symlink failures do not terminate script. Needs to be executed from script directory.

usage() {
    echo -e "Usage: $(basename "$0") [options]\n"
    echo -e "Install and configure development tools on Linux.\n"
    echo "Options:"
    echo -e "\t--shell      => Configure shell"
    echo -e "\t--mac        => Setup Mac"
    echo -e "\t--brew       => Install Brew"
    echo -e "\t--ohmyzsh    => Install Oh My ZSH"
    echo -e "\t--vscode     => Install VS Code extensions"
    echo -e "\t--vscode-save    => Save VS Code extensions to file"
    echo -e "\t--ssh-wsl    => Copy SSH config (symlink does not work in WSL)"
    echo -e "\t--force      => Force symlink create"
    echo -e "\t--help (-h)  => Show usage"
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

while :; do
    case "$1" in
        --shell) shell=1; shift;;
        --mac) mac=1; shift;;
        --brew) brew=1; shift;;
        --ohmyzsh) ohmyzsh=1; shift;;
        --vscode) vscode=1; shift;;
        --vscode-save) vscode_save=1; shift;;
        --ssh-wsl) ssh_wsl=1; shift;;
        --force) force_symlink=1; shift;;
        -h | --help) usage; exit 0;;
        *) break;;
    esac
done

[ $# -ne 0 ] && { usage; exit 1; }

run() {
    # shellcheck disable=SC2034
    declare -r files_path=$PWD/files # symlinks require full paths

    symlink="ln -sv"
    [ -n "$force_symlink" ] && symlink="ln -sfv"

    [ -n "$shell" ] && setup_shell
    [ -n "$mac" ] && setup_mac
    [ -n "$brew" ] && install_brew
    [ -n "$ohmyzsh" ] && install_ohmyzsh
    [ -n "$vscode" ] && install_vscode_extensions
    [ -n "$vscode_save" ] && save_vscode_extensions
    [ -n "$ssh_wsl" ] && setup_ssh_wsl
}

# setup_shell sets up Bash, ZSH, Tmux, SSH, Git, Vim, VS Code, etc.
setup_shell() {
    $symlink "$files_path/.bash_profile" "${HOME}/.bash_profile"
    $symlink "$files_path/.zprofile" "${HOME}/.zprofile"
    $symlink "$files_path/.profile" "${HOME}/.profile"
    $symlink "$files_path/.zshrc" "${HOME}/.zshrc"

    mkdir -p "${HOME}/.ssh" "${HOME}/.config/git"
    $symlink "$files_path/git/config" "${HOME}/.config/git/config"
    $symlink "$files_path/git/ignore" "${HOME}/.config/git/ignore"
    cp -n "$files_path/git/config_local" "${HOME}/.config/git/config_local"
    echo "Remember to adjust local git config: ~/.config/git/config_local"
    $symlink "$files_path/ssh-config" "${HOME}/.ssh/config"
    $symlink "$files_path/.tmux.conf" "${HOME}/.tmux.conf"
    $symlink "$files_path/.vimrc" "${HOME}/.vimrc"
    $symlink "$files_path/scripts" "${HOME}/"

    if [ "$(uname)" == 'Darwin' ]; then
        $symlink "$files_path/vscode.json" "$HOME/Library/Application Support/Code/User/settings.json"
        $symlink "$files_path/vscode-keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
    else
        $symlink "$files_path/vscode.json" "$HOME/.config/Code - OSS/User/settings.json"
        $symlink "$files_path/vscode-keybindings.json" "$HOME/.config/Code - OSS/User/keybindings.json"
    fi

    # shellcheck disable=SC1090,SC1091
    source "${HOME}/.profile" || echo "Failed to source ${HOME}/.profile"
}

setup_mac() {
    # Disable inverse touchpad scrolling
    defaults write .GlobalPreferences com.apple.swipescrolldirection 0
}

install_brew() {
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1
}

install_ohmyzsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || exit 1
}

install_vscode_extensions() {
    # shellcheck disable=SC2002
    cat files/vscode-ext.txt | xargs -n 1 code --install-extension
}

save_vscode_extensions() {
    code --list-extensions > files/vscode-ext.txt
}

# Copies SSH config to WSL, beacuse symlink does not work in WSL
setup_ssh_wsl() {
    mkdir -p "${HOME}/.ssh" || exit 1
    cp "$files_path/ssh-config" "${HOME}/.ssh/config" || exit 1
    sudo chmod 600 "${HOME}/.ssh/config" || exit 1
}

run
