#!/usr/bin/env bash
# Install and configure development tools.
# Symlink failures do not terminate script. Needs to be executed from script directory.

# Colors
NO_COLOR='\033[0m'
GREEN='\033[0;32m'

usage() {
    echo -e "Usage: $(basename "$0") [options]\n"
    echo -e "Install and configure development tools on Mac/Linux/WSL.\n"
    echo "Options:"
    echo -e "\t--dotfiles       => Configure dotfiles"
    echo -e "\t--mac            => Setup Mac"
    echo -e "\t--ohmyzsh        => Install Oh My ZSH"
    echo -e "\t--vscode         => Install VS Code extensions"
    echo -e "\t--vscode-save    => Save VS Code extensions to file"
    echo -e "\t--ssh-wsl        => Copy SSH config (symlink does not work in WSL)"
    echo -e "\t--force          => Force symlink create"
    echo -e "\t--help (-h)      => Show usage"
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

while :; do
    case "$1" in
        --dotfiles) dotfiles=1; shift;;
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

    [ -n "$dotfiles" ] && setup_dotfiles
    [ -n "$mac" ] && setup_mac
    [ -n "$ohmyzsh" ] && install_ohmyzsh
    [ -n "$vscode" ] && install_vscode_extensions
    [ -n "$vscode_save" ] && save_vscode_extensions
    [ -n "$ssh_wsl" ] && setup_ssh_wsl
}

# setup_dotfiles sets up Bash, ZSH, Tmux, SSH, Git, VS Code, etc.
setup_dotfiles() {
    mkdir -p "${HOME}/.ssh" "${HOME}/.config/git"

    $symlink "$files_path/shell/.bash_profile" "${HOME}/.bash_profile"
    $symlink "$files_path/shell/.zprofile" "${HOME}/.zprofile"
    $symlink "$files_path/shell/.profile" "${HOME}/.profile"
    $symlink "$files_path/shell/.zshrc" "${HOME}/.zshrc"

    $symlink "$files_path/git/config" "${HOME}/.config/git/config"
    $symlink "$files_path/git/ignore" "${HOME}/.config/git/ignore"
    cp -n "$files_path/git/config_local" "${HOME}/.config/git/config_local"
    colored_echo "Adjust local git config if needed: ~/.config/git/config_local" "$GREEN"

    if [ -n "$force_symlink" ]; then
        rm -r "${HOME}/.config/github-copilot/intellij"
    fi
    $symlink "$files_path/github-copilot/intellij" "${HOME}/.config/github-copilot/"
    $symlink "$files_path/helix/config.toml" "${HOME}/.config/helix/config.toml"
    $symlink "$files_path/tmux/.tmux.conf" "${HOME}/.tmux.conf"
    $symlink "$files_path/scripts" "${HOME}/"

    if [ "$(uname)" == 'Darwin' ]; then
        $symlink "$files_path/ssh/config-mac" "${HOME}/.ssh/config"
        $symlink "$files_path/vscode/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"
        $symlink "$files_path/vscode/settings.json" "${HOME}/Library/Application Support/Cursor/User/settings.json"
        $symlink "$files_path/vscode/keybindings.json" "${HOME}/Library/Application Support/Code/User/keybindings.json"
        $symlink "$files_path/vscode/keybindings.json" "${HOME}/Library/Application Support/Cursor/User/keybindings.json"
        if [ -n "$force_symlink" ]; then
            rm -r "${HOME}/Library/Application Support/Code/User/prompts"
        fi
        $symlink "$files_path/vscode/prompts" "${HOME}/Library/Application Support/Code/User"

		$symlink "$files_path/mac/library/Services/toggle-mic.workflow" "${HOME}/Library/Services/toggle-mic.workflow"
        $symlink "$files_path/mac/linearmouse.json" "${HOME}/.config/linearmouse/linearmouse.json"
        $symlink "$files_path/mac/karabiner.json" "${HOME}/.config/karabiner/karabiner.json"
    else
        $symlink "$files_path/ssh/config-linux" "${HOME}/.ssh/config"
        $symlink "$files_path/vscode/settings.json" "${HOME}/.config/Code - OSS/User/settings.json"
        $symlink "$files_path/vscode/settings.json" "${HOME}/.config/Cursor/User/settings.json"
        $symlink "$files_path/vscode/keybindings.json" "${HOME}/.config/Code - OSS/User/keybindings.json"
        $symlink "$files_path/vscode/keybindings.json" "${HOME}/.config/Cursor/User/keybindings.json"
    fi
}

setup_mac() {
    ## Appearance
    # Appearance -> allow wallpaper tinting in windows: disable
    defaults write NSGlobalDomain AppleReduceDesktopTinting -bool true

    # Click in the scrollbar to jump to the spot that's clicked
    defaults write NSGlobalDomain AppleScrollerPagingBehavior -int 1

    ## Dock, Menu bar and Mission Control
    # Desktop & Dock > enable autohide; setup delay and animation speed
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock autohide-time-modifier -float 0.5

    # Control Centre -> Menu Bar Only > Spotlight > Don't Show in Menu Bar
    defaults write com.apple.Spotlight MenuItemHidden -int 1

    # Decrease menu bar items spacing
    defaults write NSGlobalDomain NSStatusItemSpacing -int 10

    # Show app switcher on all displays (default: Dock display only)
    defaults write com.apple.dock appswitcher-all-displays -bool true

    # Desktop & Dock -> Windows -> tiled windows have margins: disable
    defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

    # Desktop & Dock -> automatically rearrange Spaces based on most recent use: disable
    defaults write com.apple.dock workspaces-auto-swoosh -bool false

    # Desktop & Dock -> when switching to an application, switch to a space with open windows for the application: enable
    defaults write com.apple.dock AppleSpacesSwitchOnActivate -bool true

    # Desktop & Dock -> desktop & stage manager -> click wallpaper to reveal desktop: only in stage manager
    defaults write com.apple.dock showDesktopOnlyInSM -bool true

    # Desktop & Dock -> hot corners -> upper left: mission control
    defaults write com.apple.dock wvous-tl-corner -int 2
    defaults write com.apple.dock wvous-tl-modifier -int 0

    # Desktop & Dock -> Windows & Apps > Prefer tabs when opening documents
    defaults write NSGlobalDomain AppleWindowTabbingMode -string "fullscreen"

    ## Finder
    # Finder > Preferences > Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Allow quitting Finder via ⌘ + Q; doing so will also hide desktop icons
    defaults write com.apple.finder QuitMenuItem -bool true

    # Finder > View > Show Path Bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Finder > General > New Finder window show: Home Directory
    defaults write com.apple.finder NewWindowTarget -string "PfHm"
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

    # Finder > Advanced > Remove items from the Bin after 30 days: enable
    defaults write com.apple.finder FXRemoveOldTrashItems -bool true

    # Finder > Advanced > Keep folders on top: in windows when sorting by name
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

    # Finder > Advanced > When performing a search: search the current folder
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Finder > default view > List View
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Show hidden ~/Library folder in Finder
    chflags nohidden ~/Library

    ## Keyboard
    # Setup system shorcuts # TODO: fix
    #setup_mac_shortcuts

    # Keyboard -> delay until repeat: 15*15 ms; key repeat rate: 2*15 ms
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    defaults write NSGlobalDomain KeyRepeat -int 2

    # Keyboard -> keyboard navigation: enable
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

    # Keyboard -> configure single press of fn key to "do nothing"
    defaults write com.apple.HIToolbox AppleFnUsageType -int 0

    ## Mouse
    # Disable mouse acceleration
    defaults write NSGlobalDomain com.apple.mouse.scaling -1

    ## Battery
    # Battery -> options -> slightly dim the display on battery: disable
    defaults write com.apple.controlcenter DimDisplayOnBattery -bool false

    ## Misc
    # Avoid creation of .DS_Store files on network volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

    # Disable quarantine for e.g. video files
    defaults write com.apple.LaunchServices LSQuarantine -bool false

    # Set screenshots location to ~/Pictures/ss (default: ~/Desktop)
    screenshotDir="${HOME}/Pictures/ss"
    mkdir -p "${screenshotDir}"
    defaults write com.apple.screencapture location -string "${screenshotDir}"

	## External apps
	# Use cmd+tab and cmd+~ to switch apps in Alt-Tab
	defaults write com.lwouis.alt-tab-macos holdShortcut "\\U2318"
	defaults write com.lwouis.alt-tab-macos holdShortcut2 "\\U2318"

    # Kill affected apps
    echo "Restarting system processes to apply changes..."
    killall cfprefsd # Restart the preferences daemon to ensure all plist changes are applied
    killall Dock Finder SystemUIServer
    echo "Changes applied. For some keyboard settings, you may need to log out and log back in."
}

setup_mac_shortcuts() {
    # Keyboard -> shortcuts -> launchpad & dock -> disable: turn dock hiding on/off (ID 52)
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 52 "{enabled = 0;}"

    # Keyboard -> shortcuts -> mission control -> mission control: ctrl+cmd+S
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 "{enabled = 1; value = { parameters = (1, 4352, 1048576); type = 'standard'; };}"

    # Keyboard -> shortcuts -> mission control -> application windows: ctrl+cmd+A
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 33 "{enabled = 1; value = { parameters = (97, 0, 1310720); type = 'standard'; };}"

    # Keyboard -> shortcuts -> mission control -> move left a space: ctrl+cmd+left
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 "{enabled = 1; value = { parameters = (123, 4352, 1048576); type = 'standard'; };}"

    # Keyboard -> shortcuts -> mission control -> move right a space: ctrl+cmd+right
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 "{enabled = 1; value = { parameters = (124, 4352, 1048576); type = 'standard'; };}"

    # Keyboard -> shortcuts -> mission control -> disable "Show Desktop"
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 36 "{enabled = 0;}"

    # Keyboard -> shortcuts -> mission control -> disable "Quick Note"
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 190 "{enabled = 0;}"

    # Keyboard -> shortcuts -> input sources -> disable: select next/previous input source
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "{enabled = 0;}"
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "{enabled = 0;}"

    # Keyboard -> shortcuts -> accessibility -> disable: show accessibility controls
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 162 "{enabled = 0;}"

    # Keyboard -> shortcuts -> accessibility -> disable: turn VoiceOver on or off
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 59 "{enabled = 0;}"

    # Export the symbolic hotkeys to ensure they persist across system restarts
    defaults export com.apple.symbolichotkeys ~/Library/Preferences/com.apple.symbolichotkeys.plist

    # Keyboard -> shortcuts -> services -> files and folders -> disable: send file to bluetooth device
    defaults write pbs NSServicesStatus -dict-add 'com.apple.BluetoothFileExchange - sendFile' '{enabled = 0;}'

    # Keyboard -> shortcuts -> services -> searching -> disable: search with google, spotlight
    defaults write pbs NSServicesStatus -dict-add 'com.apple.Safari - Search With %WebSearchProvider@ - searchWithWebSearchProvider' '{enabled = 0;}'
    defaults write pbs NSServicesStatus -dict-add 'com.apple.Spotlight - showSpotlightSearch - spotlightSearchText' '{enabled = 0;}'

    # Keyboard -> shortcuts -> services -> text -> disable: various text services
    defaults write pbs NSServicesStatus -dict-add 'com.apple.ChineseTextConverterService - Simplified - convertTextToSimplifiedChinese' '{enabled = 0;}'
    defaults write pbs NSServicesStatus -dict-add 'com.apple.ChineseTextConverterService - Traditional - convertTextToTraditionalChinese' '{enabled = 0;}'
    defaults write pbs NSServicesStatus -dict-add 'com.apple.StickiesService - Make Sticky - makeStickyFromSelection' '{enabled = 0;}'
    defaults write pbs NSServicesStatus -dict-add 'com.apple.Terminal - Open man Page in Terminal - openManPage' '{enabled = 0;}'
    defaults write pbs NSServicesStatus -dict-add 'com.apple.Terminal - Search man Page Index in Terminal - searchManPages' '{enabled = 0;}'

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

colored_echo() {
    echo -e "${2}${1}${NO_COLOR}"
}

run
