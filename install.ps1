# Install and configure software on Windows system.
# TODO: use file paths relative to script directory
# TODO: export functionality as Powershell functions or some other mechanism

# Symlink Windows Terminal config
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\winterm-settings.json -Path $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Force

# Symlink SSH config
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\ssh-config-win -Path $env:USERPROFILE\.ssh\config -Force

# Symlink git config
mkdir $env:USERPROFILE\.config\git
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\git\config -Path $env:USERPROFILE\.config\git\config -Force
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\git\ignore -Path $env:USERPROFILE\.config\git\ignore -Force
# Copy-Item -Path D:\projects\dotfiles\files\git\config_local -Destination $env:USERPROFILE\.config\git\config_local # including file does not work on Win

# Symlink VS Code config
# Remove config files if needed: Remove-Item -Path $env:APPDATA\Code\User\settings.json
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\vscode.json -Path $env:APPDATA\Code\User\settings.json -Force

## Games

# Symlink CS: GO config
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\games\csgo\autoexec.cfg -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\autoexec.cfg' -Force
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\games\csgo\bots.cfg -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\bots.cfg' -Force
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\games\csgo\practice.cfg -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\practice.cfg' -Force
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\games\csgo\video.txt -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\video.txt' -Force

# Copy CS 1.6 config (symlink does not work)
Copy-Item -Path D:\projects\dotfiles\files\games\cs16\userconfig.cfg -Destination 'C:\Program Files (x86)\Steam\steamapps\common\Half-Life\cstrike\userconfig.cfg' -Force

# Symlink ET config
$mydocuments = [environment]::getfolderpath(“mydocuments”)
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\games\et\autoexec.cfg -Path $mydocuments\ETLegacy\etmain\autoexec.cfg -Force
# Copy ET Legacy to steam folder and create a symlink to its executables (as below)
New-Item -ItemType SymbolicLink -Target "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\etl.exe" -Path "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\et.exe" -Force
New-Item -ItemType SymbolicLink -Target "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\etlded.exe" -Path "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\etded.exe" -Force
