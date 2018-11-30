REM Symlink configuration files on Windows system
REM Remove configuration files if needed: del %appdata%\Code\User\settings.json

REM Symlink git configuration
mklink %userprofile%\.gitconfig D:\Dropbox\dotfiles\files\.gitconfig
mklink %userprofile%\.gitconfig_local D:\Dropbox\dotfiles\files\.gitconfig_local
mklink %userprofile%\.gitignore_global D:\Dropbox\dotfiles\files\.gitignore_global

REM Symlink VS Code configuration
mklink %appdata%\Code\User\settings.json D:\Dropbox\dotfiles\files\vscode\settings.json
