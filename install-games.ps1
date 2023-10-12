# Symlink CS: GO config
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\games\cs\autoexec.cfg -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\autoexec.cfg' -Force
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\games\cs\bots.cfg -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\bots.cfg' -Force
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\games\cs\practice.cfg -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\practice.cfg' -Force
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\games\cs\video.txt -Path 'C:\Program Files (x86)\Steam\userdata\28059286\730\local\cfg\video.txt' -Force

# Copy CS 1.6 config (symlink does not work)
Copy-Item -Path D:\projects\dotfiles\files\games\cs16\userconfig.cfg -Destination 'C:\Program Files (x86)\Steam\steamapps\common\Half-Life\cstrike\userconfig.cfg' -Force

# Symlink ET config
$mydocuments = [environment]::getfolderpath(“mydocuments”)
New-Item -ItemType SymbolicLink -Target D:\projects\dotfiles\files\games\et\autoexec.cfg -Path $mydocuments\ETLegacy\etmain\autoexec.cfg -Force
# Copy ET Legacy to steam folder and create a symlink to its executables (as below)
New-Item -ItemType SymbolicLink -Target "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\etl.exe" -Path "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\et.exe" -Force
New-Item -ItemType SymbolicLink -Target "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\etlded.exe" -Path "D:\games\steam\steamapps\common\Wolfenstein Enemy Territory\etded.exe" -Force
