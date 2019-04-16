# Install and configure software on Windows system.
# Remove configuration files if needed: Remove-Item -Path $env:APPDATA\Code\User\settings.json
# TODO: use file paths relative to script directory
# TODO: export functionality as Powershell functions or some other mechanism

# Symlink git configuration
New-Item -ItemType SymbolicLink -Value D:\Dropbox\dotfiles\files\.gitconfig -Path $env:USERPROFILE\.gitconfig
New-Item -ItemType SymbolicLink -Value D:\Dropbox\dotfiles\files\.gitignore_global -Path $env:USERPROFILE\.gitignore_global
Copy-Item -Path $env:USERPROFILE\.gitconfig_local -Destination D:\Dropbox\dotfiles\files\.gitconfig_local

# Symlink VS Code configuration
New-Item -ItemType SymbolicLink -Value D:\Dropbox\dotfiles\files\vscode\settings.json -Path $env:APPDATA\Code\User\settings.json

# Symlink CS 1.6 configuration
New-Item -ItemType SymbolicLink -Value D:\Dropbox\dotfiles\files\games\cs16\userconfig.cfg -Path 'C:\Program Files (x86)\Steam\steamapps\common\Half-Life\cstrike\userconfig.cfg'
