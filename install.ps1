# Install and configure software on Windows system.
# Remove configuration files if needed: Remove-Item -Path $env:APPDATA\Code\User\settings.json
# TODO: use file paths relative to script directory
# TODO: export functionality as Powershell functions or some other mechanism

# Symlink git configuration
New-Item -ItemType SymbolicLink -Value D:\Dropbox\dotfiles\files\.gitconfig -Path $env:USERPROFILE\.gitconfig
New-Item -ItemType SymbolicLink -Value D:\Dropbox\dotfiles\files\.gitignore_global -Path $env:USERPROFILE\.gitignore_global
Copy-Item -Path D:\Dropbox\dotfiles\files\.gitconfig_local -Destination $env:USERPROFILE\.gitconfig_local

# Symlink VS Code configuration
New-Item -ItemType SymbolicLink -Value D:\Dropbox\dotfiles\files\vscode\settings.json -Path $env:APPDATA\Code\User\settings.json

# Symlink CS: GO configuration
New-Item -ItemType SymbolicLink -Value D:\Dropbox\dotfiles\files\games\csgo\autoexec.cfg -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\autoexec.cfg'

# Copy CS 1.6 configuration (symlink does not work)
Copy-Item -Path D:\Dropbox\dotfiles\files\games\cs16\userconfig.cfg -Destination 'C:\Program Files (x86)\Steam\steamapps\common\Half-Life\cstrike\userconfig.cfg'

# Symlink ET configuration
$mydocuments = [environment]::getfolderpath(“mydocuments”)
New-Item -ItemType SymbolicLink -Value D:\Dropbox\dotfiles\files\games\et\autoexec.cfg -Path $mydocuments\ETLegacy\etmain\autoexec.cfg
