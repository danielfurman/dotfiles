# Install and configure software on Windows system.
# TODO: use file paths relative to script directory
# TODO: export functionality as Powershell functions or some other mechanism

# Symlink Windows Terminal config
New-Item -ItemType SymbolicLink -Target D:\synology\dotfiles\files\winterm-settings.json -Path $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

# Symlink SSH config
New-Item -ItemType SymbolicLink -Target D:\synology\dotfiles\files\ssh-config-win -Path $env:USERPROFILE\.ssh\config

# Symlink git config
mkdir $env:USERPROFILE\.config\git
New-Item -ItemType SymbolicLink -Target D:\synology\dotfiles\files\git\config -Path $env:USERPROFILE\.config\git\config
New-Item -ItemType SymbolicLink -Target D:\synology\dotfiles\files\git\ignore -Path $env:USERPROFILE\.config\git\ignore
# Copy-Item -Path D:\synology\dotfiles\files\git\config_local -Destination $env:USERPROFILE\.config\git\config_local # including file does not work on Win

# Symlink VS Code config
# Remove config files if needed: Remove-Item -Path $env:APPDATA\Code\User\settings.json
New-Item -ItemType SymbolicLink -Target D:\synology\dotfiles\files\vscode.json -Path $env:APPDATA\Code\User\settings.json

## Games

# Symlink CS: GO config
New-Item -ItemType SymbolicLink -Target D:\synology\dotfiles\files\games\csgo\autoexec.cfg -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\autoexec.cfg'
New-Item -ItemType SymbolicLink -Target D:\synology\dotfiles\files\games\csgo\bots.cfg -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\bots.cfg'
New-Item -ItemType SymbolicLink -Target D:\synology\dotfiles\files\games\csgo\practice.cfg -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\practice.cfg'
New-Item -ItemType SymbolicLink -Target D:\synology\dotfiles\files\games\csgo\video.txt -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\video.txt'

# Copy CS 1.6 config (symlink does not work)
Copy-Item -Path D:\synology\dotfiles\files\games\cs16\userconfig.cfg -Destination 'C:\Program Files (x86)\Steam\steamapps\common\Half-Life\cstrike\userconfig.cfg'

# Symlink ET config
$mydocuments = [environment]::getfolderpath(“mydocuments”)
New-Item -ItemType SymbolicLink -Target D:\synology\dotfiles\files\games\et\autoexec.cfg -Path $mydocuments\ETLegacy\etmain\autoexec.cfg
# Copy ET Legacy to steam folder and create a symlink to its executables
New-Item -ItemType SymbolicLink -Target "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\etl.exe" -Path "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\et.exe"
New-Item -ItemType SymbolicLink -Target "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\etlded.exe" -Path "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\etded.exe"
