#!/usr/bin/env bash
# Install and configure development tools.
# Symlink failures do not terminate script. Needs to be executed from script directory.

# Colors
NOCOLOR='\033[0m'
GREEN='\033[0;32m'

usage() {
    echo -e "Usage: $(basename "$0") [options]\n"
    echo -e "Install and configure development tools on Linux.\n"
    echo "Options:"
    echo -e "\t--shell      => Configure shell"
    echo -e "\t--mac        => Setup Mac"
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
        --ohmyzsh) ohmyzsh=1; shift;;
        --vscode) vscode=1; shift;;
        --vscode-save) vscode_save=1; shift;;
        --ssh-wsl) ssh_wsl=1; shift;;
        --force) force_symlink=1; shift;;
        -h | --help) usage; exit 0;;
        *) break;;
    esac
done

run() {
    # shellcheck disable=SC2034
    declare -r files_path=$PWD/files # symlinks require full paths

    symlink="ln -sv"
    [ -n "$force_symlink" ] && symlink="ln -sfv"

    [ -n "$shell" ] && setup_shell
    [ -n "$mac" ] && setup_mac
    [ -n "$ohmyzsh" ] && install_ohmyzsh
    [ -n "$vscode" ] && install_vscode_extensions
    [ -n "$vscode_save" ] && save_vscode_extensions
    [ -n "$ssh_wsl" ] && setup_ssh_wsl
}

# setup_shell sets up Bash, ZSH, Tmux, SSH, Git, VS Code, etc.
setup_shell() {
    mkdir -p "${HOME}/.ssh" "${HOME}/.config/git"

    $symlink "$files_path/shell/.bash_profile" "${HOME}/.bash_profile"
    $symlink "$files_path/shell/.zprofile" "${HOME}/.zprofile"
    $symlink "$files_path/shell/.profile" "${HOME}/.profile"
    $symlink "$files_path/shell/.zshrc" "${HOME}/.zshrc"

    $symlink "$files_path/git/config" "${HOME}/.config/git/config"
    $symlink "$files_path/git/ignore" "${HOME}/.config/git/ignore"
    cp -n "$files_path/git/config_local" "${HOME}/.config/git/config_local"
    coloredEcho "Adjust local git config if needed: ~/.config/git/config_local" "$GREEN"

    $symlink "$files_path/helix/config.toml" "${HOME}/.config/helix/config.toml"
    $symlink "$files_path/tmux/.tmux.conf" "${HOME}/.tmux.conf"
    $symlink "$files_path/scripts" "${HOME}/"

    if [ "$(uname)" == 'Darwin' ]; then
        $symlink "$files_path/ssh/config-mac" "${HOME}/.ssh/config"
        $symlink "$files_path/vscode/vscode.json" "${HOME}/Library/Application Support/Code/User/settings.json"
        $symlink "$files_path/vscode/vscode-keybindings.json" "${HOME}/Library/Application Support/Code/User/keybindings.json"
        $symlink "$files_path/mac/linearmouse.json" "${HOME}/.config/linearmouse/linearmouse.json"
    else
        $symlink "$files_path/ssh/config-linux" "${HOME}/.ssh/config"
        $symlink "$files_path/vscode/vscode.json" "${HOME}/.config/Code - OSS/User/settings.json"
        $symlink "$files_path/vscode/vscode-keybindings.json" "${HOME}/.config/Code - OSS/User/keybindings.json"
    fi
}

setup_mac() {
    ## Dock, Menubar and Mission Control
    # Desktop & Dock > enable autohide
    defaults write com.apple.dock autohide -bool true

    # Disable Dock autohide delay
    defaults write com.apple.dock autohide-delay -float 0

    # Speed up Dock animation
    defaults write com.apple.dock autohide-time-modifier -float 0.5

    # Decrease menu bar items spacing
    defaults write .GlobalPreferences NSStatusItemSpacing -int 10

    # Show app switcher on all displays (default: Dock display only)
    defaults write com.apple.dock appswitcher-all-displays -bool true

    # Desktop # Dock -> automatically rearrange Spaces based on most recent use: disable
    defaults write com.apple.dock workspaces-auto-swoosh -bool NO

    ## Finder
    # Finder > Preferences > Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Allow quitting Finder via ⌘ + Q; doing so will also hide desktop icons
    defaults write com.apple.finder QuitMenuItem -bool true

    # Finder > View > Show Path Bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Show hidden ~/Library folder in Finder
    chflags nohidden ~/Library

    ## Keyboard
    # Keyboard -> delay until repeat: 225 ms; key repeat rate: 30 ms
    defaults write .GlobalPreferences InitialKeyRepeat -int 15
    defaults write .GlobalPreferences KeyRepeat -int 2

    ## Mouse
    # Disable mouse acceleration
    defaults write .GlobalPreferences com.apple.mouse.scaling -1

    ## Other
    # Avoid creation of .DS_Store files on network volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

    # Disable quarantine for e.g. video files
    defaults write com.apple.LaunchServices LSQuarantine -bool false

    # Set screenshots location to ~/Pictures/ss (default: ~/Desktop)
    screenshotDir="${HOME}/Pictures/ss"
    mkdir -p "${screenshotDir}"
    defaults write com.apple.screencapture location -string "${screenshotDir}"

    # Kill affected apps
    killall Dock Finder
}

install_ohmyzsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || exit 1
}

install_vscode_extensions() {
    # shellcheck disable=SC2002
    cat files/vscode/vscode-ext.txt | xargs -n 1 code --install-extension
}

save_vscode_extensions() {
    code --list-extensions > files/vscode/vscode-ext.txt
}

# Copies SSH config to WSL, because symlink does not work in WSL
setup_ssh_wsl() {
    mkdir -p "${HOME}/.ssh" || exit 1
    cp "$files_path/ssh/config-linux" "${HOME}/.ssh/config" || exit 1
    sudo chmod 600 "${HOME}/.ssh/config" || exit 1
}

coloredEcho() {
    echo -e "${2}${1}${NOCOLOR}"
}

run
