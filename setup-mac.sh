#!/usr/bin/env bash
# Setup Mac OS

run() {
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

    # Desktop & Dock -> Windows & Apps > Prefer tabs when opening documents: always
    defaults write NSGlobalDomain AppleWindowTabbingMode -string "always"

    ## Spotlight

    defaults write com.apple.Spotlight EnabledPreferenceRules -array "Custom.relatedContents" "com.apple.iBooksX" "com.hnc.Discord" \
        "com.apple.mail" "com.apple.podcasts" "com.apple.Safari" "net.whatsapp.WhatsApp" "com.microsoft.rdc.macos"
    defaults write com.apple.Spotlight PasteboardHistoryEnabled -int 1
    defaults write com.apple.Spotlight PasteboardHistoryTimeout -int 1800

    ## Finder

    # Finder > Preferences > Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Allow quitting Finder via ⌘ + Q; doing so will also hide desktop icons
    defaults write com.apple.finder QuitMenuItem -bool true

    # Finder > View > Show Path Bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Finder > General > New Finder window show: Home Directory
    defaults write com.apple.finder NewWindowTarget -string "PfHm"
    defaults write com.apple.finder NewWindowTargetPath -string "file://$(printf '%s' ~)/"

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

    # Setup system shorcuts
    setup_mac_shortcuts

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

    # Set screenshots location to ~/Pictures/ss (default: ~/Desktop)
    screenshotDir=~/Pictures/ss
    mkdir -p "${screenshotDir}"
    defaults write com.apple.screencapture location -string "${screenshotDir}"

    ## External apps

    # Use cmd+tab and cmd+~ to switch apps in Alt-Tab
    defaults write com.lwouis.alt-tab-macos holdShortcut "\\U2318"
    defaults write com.lwouis.alt-tab-macos holdShortcut2 "\\U2318"

    ## Apply changes
    echo "Restarting system processes to apply changes"
    killall cfprefsd # Restart the preferences daemon to ensure all plist changes are applied
    killall Dock Finder SystemUIServer
    echo "Changes applied. For some keyboard settings, you may need to log out and log back in."
}

setup_mac_shortcuts() {
    local symbolicHotkeysPlist=~/Library/Preferences/com.apple.symbolichotkeys.plist
    local pbsPlist=~/Library/Preferences/pbs.plist

    # Keyboard -> shortcuts -> launchpad & dock -> disable: turn dock hiding on/off (ID 52)
    plutil -replace "AppleSymbolicHotKeys.52" -json '{"enabled":0,"value":{"parameters":[100,2,1572864],"type":"standard"}}' "${symbolicHotkeysPlist}"

    # Keyboard -> shortcuts -> mission control -> mission control: ctrl+cmd+S
    plutil -replace "AppleSymbolicHotKeys.32" -json '{"enabled":1,"value":{"parameters":[115,1,1310720],"type":"standard"}}' "${symbolicHotkeysPlist}"

    # Keyboard -> shortcuts -> mission control -> application windows: ctrl+cmd+A
    plutil -replace "AppleSymbolicHotKeys.33" -json '{"enabled":1,"value":{"parameters":[97,0,1310720],"type":"standard"}}' "${symbolicHotkeysPlist}"

    # Keyboard -> shortcuts -> mission control -> move left a space: ctrl+cmd+left
    plutil -replace "AppleSymbolicHotKeys.79" -json '{"enabled":1,"value":{"parameters":[65535,123,9699328],"type":"standard"}}' "${symbolicHotkeysPlist}"

    # Keyboard -> shortcuts -> mission control -> move right a space: ctrl+cmd+right
    plutil -replace "AppleSymbolicHotKeys.81" -json '{"enabled":1,"value":{"parameters":[65535,124,9699328],"type":"standard"}}' "${symbolicHotkeysPlist}"

    # Keyboard -> shortcuts -> mission control -> disable "Show Desktop"
    plutil -replace "AppleSymbolicHotKeys.36" -json '{"enabled":0,"value":{"parameters":[65535,103,8388608],"type":"standard"}}' "${symbolicHotkeysPlist}"

    # Keyboard -> shortcuts -> mission control -> disable "Quick Note"
    plutil -replace "AppleSymbolicHotKeys.190" -json '{"enabled":0,"value":{"parameters":[113,12,8388608],"type":"standard"}}' "${symbolicHotkeysPlist}"

    # Keyboard -> shortcuts -> input sources -> disable: select next/previous input source
    plutil -replace "AppleSymbolicHotKeys.60" -json '{"enabled":0,"value":{"parameters":[32,49,262144],"type":"standard"}}' "${symbolicHotkeysPlist}"
    plutil -replace "AppleSymbolicHotKeys.61" -json '{"enabled":0,"value":{"parameters":[32,49,786432],"type":"standard"}}' "${symbolicHotkeysPlist}"

    # Keyboard -> shortcuts -> accessibility -> disable: show accessibility controls
    plutil -replace "AppleSymbolicHotKeys.162" -json '{"enabled":0,"value":{"parameters":[65535,96,9961472],"type":"standard"}}' "${symbolicHotkeysPlist}"

    # Keyboard -> shortcuts -> accessibility -> disable: turn VoiceOver on or off
    plutil -replace "AppleSymbolicHotKeys.59" -json '{"enabled":0,"value":{"parameters":[65535,96,9437184],"type":"standard"}}' "${symbolicHotkeysPlist}"

    # Keyboard -> shortcuts -> services -> searching -> disable: search with google
    plutil -replace "NSServicesStatus.com\.apple\.Safari - Search With %WebSearchProvider@ - searchWithWebSearchProvider" \
	-json '{"enabled_context_menu":0,"enabled_services_menu":0,"presentation_modes":{"ContextMenu":0,"ServicesMenu":0}}' "${pbsPlist}"

    # Keyboard -> shortcuts -> services -> text -> disable: various text services
    plutil -replace "NSServicesStatus.com\.apple\.ChineseTextConverterService - Convert Text from Traditional to Simplified Chinese - convertTextToSimplifiedChinese" \
        -json '{"enabled_context_menu":0,"enabled_services_menu":0,"presentation_modes":{"ContextMenu":0,"ServicesMenu":0}}' "${pbsPlist}"
    plutil -replace "NSServicesStatus.com\.apple\.ChineseTextConverterService - Convert Text from Simplified to Traditional Chinese - convertTextToTraditionalChinese" \
        -json '{"enabled_context_menu":0,"enabled_services_menu":0,"presentation_modes":{"ContextMenu":0,"ServicesMenu":0}}' "${pbsPlist}"
    plutil -replace "NSServicesStatus.com\.apple\.Stickies - Make Sticky - makeStickyFromTextService" \
        -json '{"enabled_services_menu":0,"presentation_modes":{"ContextMenu":0,"ServicesMenu":0}}' "${pbsPlist}"
    plutil -replace "NSServicesStatus.com\.apple\.Terminal - Open man Page in Terminal - openManPage" \
        -json '{"enabled_context_menu":0,"enabled_services_menu":0,"presentation_modes":{"ContextMenu":0,"ServicesMenu":0}}' "${pbsPlist}"
    plutil -replace "NSServicesStatus.com\.apple\.Terminal - Search man Page Index in Terminal - searchManPages" \
        -json '{"enabled_context_menu":0,"enabled_services_menu":0,"presentation_modes":{"ContextMenu":0,"ServicesMenu":0}}' "${pbsPlist}"
}

run
