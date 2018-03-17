REM  Symlink configuration files on Windows system

REM Symlink VS Code settings
del %appdata%\Code\User\settings.json
mklink %appdata%\Code\User\settings.json D:\Dropbox\dotfiles\files\vscode\settings.json
