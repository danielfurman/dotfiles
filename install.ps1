# Install and configure software on Windows system.
# TODO: use file paths relative to script directory
# TODO: export functionality as Powershell functions or some other mechanism

## Windows settings
# Control panel -> hardware and sound -> keyboard -> key repeat delay and key repeat rate
Set-ItemProperty -Path  "Registry::HKEY_CURRENT_USER\Control Panel\Keyboard" KeyboardDelay 0
Set-ItemProperty -Path  "Registry::HKEY_CURRENT_USER\Control Panel\Keyboard" KeyboardSpeed 50

## Tools configuration

# Symlink Windows Terminal config
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\winterm\settings.json -Path $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Force

# Symlink SSH config
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\ssh\config-win -Path $env:USERPROFILE\.ssh\config -Force

# Symlink git config
mkdir $env:USERPROFILE\.config\git
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\git\config -Path $env:USERPROFILE\.config\git\config -Force
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\git\ignore -Path $env:USERPROFILE\.config\git\ignore -Force

# Symlink VS Code config
# Remove config files if needed: Remove-Item -Path $env:APPDATA\Code\User\settings.json
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\vscode\vscode.json -Path $env:APPDATA\Code\User\settings.json -Force
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\vscode\vscode-keybindings.json -Path $env:APPDATA\Code\User\keybindings.json -Force
