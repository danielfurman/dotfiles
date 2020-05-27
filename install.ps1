# Install and configure software on Windows system.
# Remove configuration files if needed: Remove-Item -Path $env:APPDATA\Code\User\settings.json
# TODO: use file paths relative to script directory
# TODO: export functionality as Powershell functions or some other mechanism

# Symlink git configuration
New-Item -ItemType SymbolicLink -Value D:\synology\dotfiles\files\.gitconfig -Path $env:USERPROFILE\.gitconfig
New-Item -ItemType SymbolicLink -Value D:\synology\dotfiles\files\.gitignore_global -Path $env:USERPROFILE\.gitignore_global
Copy-Item -Path D:\synology\dotfiles\files\.gitconfig_local -Destination $env:USERPROFILE\.gitconfig_local

# Symlink VS Code configuration
New-Item -ItemType SymbolicLink -Value D:\synology\dotfiles\files\vscode.json -Path $env:APPDATA\Code\User\settings.json

# Install Go
choco install golang
setx GOPATH D:\projects\gopath

# Symlink CS: GO configuration
New-Item -ItemType SymbolicLink -Value D:\synology\dotfiles\files\games\csgo\autoexec.cfg -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\autoexec.cfg'
New-Item -ItemType SymbolicLink -Value D:\synology\dotfiles\files\games\csgo\bots.cfg -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\bots.cfg'
New-Item -ItemType SymbolicLink -Value D:\synology\dotfiles\files\games\csgo\practice.cfg -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\practice.cfg'
New-Item -ItemType SymbolicLink -Value D:\synology\dotfiles\files\games\csgo\video.txt -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\video.txt'

# Copy CS 1.6 configuration (symlink does not work)
Copy-Item -Path D:\synology\dotfiles\files\games\cs16\userconfig.cfg -Destination 'C:\Program Files (x86)\Steam\steamapps\common\Half-Life\cstrike\userconfig.cfg'

# Symlink ET configuration
$mydocuments = [environment]::getfolderpath(“mydocuments”)
New-Item -ItemType SymbolicLink -Value D:\synology\dotfiles\files\games\et\autoexec.cfg -Path $mydocuments\ETLegacy\etmain\autoexec.cfg
