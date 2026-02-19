# Symlink CS 2 config
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\games\cs\autoexec.cfg -Path 'D:\games\steam\steamapps\common\Counter-Strike Global Offensive\game\cs\cfg\autoexec.cfg' -Force
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\games\cs\bots.cfg -Path 'D:\games\steam\steamapps\common\Counter-Strike Global Offensive\game\cs\cfg\bots.cfg' -Force
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\games\cs\practice.cfg -Path 'D:\games\steam\steamapps\common\Counter-Strike Global Offensive\game\cs\cfg\practice.cfg' -Force

# Copy CS 1.6 config (symlink does not work)
Copy-Item -Path D:\projects\dotfiles\files\games\cs16\userconfig.cfg -Destination 'C:\Program Files (x86)\Steam\steamapps\common\Half-Life\cstrike\userconfig.cfg' -Force

# Symlink ET config
$mydocuments = [environment]::getfolderpath(“mydocuments”)
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\games\et\autoexec.cfg -Path $mydocuments\ETLegacy\etmain\autoexec.cfg -Force

# Setup ET on Steam: copy ET Legacy to steam folder and create a symlink to its executables (as below)
New-Item -ItemType SymbolicLink -Target "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\etl.exe" -Path "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\et.exe" -Force
New-Item -ItemType SymbolicLink -Target "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\etlded.exe" -Path "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\etded.exe" -Force
