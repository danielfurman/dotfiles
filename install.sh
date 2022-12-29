#!/usr/bin/env bash
# Install and configure development tools.
# Symlink failures do not terminate script.
# TODO: use if; then; fi where possible
# TODO: make script execution path independent
# TODO: target "all" does not make sense now
# TODO: use "die" instead of "return 1"

usage() {
    echo -e "Usage: $(basename "$0") [options]\n"
    echo -e "Install and configure development tools on Linux.\n"
    echo "Options:"
    echo -e "\t--all        => Install and configure all tools"
    echo -e "\t--shell      => Configure shell"
    echo -e "\t--ssh-wsl    => Copy SSH config (symlink does not work in WSL)"
    echo -e "\t--ssh-key    => Generate SSH key"
    echo -e "\t--vscode     => Install VS Code plugins"
    echo -e "\t--force      => Force symlink create"
    echo -e "\t--help (-h)  => Show usage"
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

while :; do
    case "$1" in
        --all) all=1; shift;;
        --shell) shell=1; shift;;
        --ssh-wsl) sshwsl=1; shift;;
        --ssh-key) sshkey=1; shift;;
        --brew) brew=1; shift;;
        --vscode) vscode=1; shift;;
        --force) force_symlink=1; shift;;
        -h | --help) usage; exit 0;;
        *) break;;
    esac
done

[ $# -ne 0 ] && { usage; exit 1; }

run() {
    # shellcheck disable=SC2034
    local readonly files_path=$PWD/files

    ensure_tools || return 1

    symlink="ln -sv"
    [[ -v force_symlink ]] && symlink="ln -sfv"

    [[ -v shell || -v all ]] && (setup_shell || return 1)
    [[ -v sshwsl || -v all ]] && (setup_ssh_wsl || return 1)
    [[ -v sshkey || -v all ]] && (generate_ssh_key || return 1)
    [[ -v brew || -v all ]] && (setup_brew || return 1)
    [[ -v vscode || -v all ]] && (install_vscode_plugins || return 1)

    return 0
}

ensure_tools() {
    command -v curl git wget ||
        sudo pacman -S --noconfirm curl git wget ||
        sudo apt install -y curl git wget ||
        brew install curl git wget ||
        return 1
}

# setup_shell sets up Bash, ZSH, Tmux, SSH, Git, Vim, VS Code, etc.
setup_shell() {
    # TODO: idempotentify text appending
    # shellcheck disable=SC2016
    {
        echo 'if [ -r "${HOME}/.profile" ]; then source "${HOME}/.profile"; fi' >> "${HOME}/.bash_profile"
        echo 'case "$-" in *i*) if [ -r "${HOME}/.bashrc" ]; then source "${HOME}/.bashrc"; fi;; esac' >> "${HOME}/.bash_profile"

        echo 'if [ -r "${HOME}/.profile" ]; then source "${HOME}/.profile"; fi' >> "${HOME}/.zprofile"

        echo "Files modified: ~/.profile ~/.bash_profile ~/.zprofile"
    }

    $symlink "$files_path/profile.sh" "${HOME}/.profile"
    $symlink "$files_path/zshrc.sh" "${HOME}/.zshrc"

    mkdir -p "${HOME}/.ssh" "${HOME}/.config/git"
    $symlink "$files_path/git/config" "${HOME}/.config/git/config"
    $symlink "$files_path/git/ignore" "${HOME}/.config/git/ignore"
    cp -n "$files_path/git/config_local" "${HOME}/.config/git/config_local"
    echo "Remember to adjust local git config: ~/.config/git/config_local"
    $symlink "$files_path/ssh-config" "${HOME}/.ssh/config"
    $symlink "$files_path/tmux.conf" "${HOME}/.tmux.conf"
    $symlink "$files_path/vimrc" "$HOME/.vimrc"
    $symlink "$files_path/scripts" "${HOME}/"

    if [ "$(uname)" == 'Darwin' ]; then
        $symlink "$files_path/vscode.json" "$HOME/Library/Application Support/Code/User/settings.json"
        $symlink "$files_path/vscode-keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
    else
        $symlink "$files_path/vscode.json" "$HOME/.config/Code - OSS/User/settings.json"
        $symlink "$files_path/vscode-keybindings.json" "$HOME/.config/Code - OSS/User/keybindings.json"
    fi

    # shellcheck disable=SC1090,SC1091
    source "${HOME}/.profile" || echo "Failed to source ${HOME}/.profile"

    # It does not always exit, so it is put as last command
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || return 1
}

setup_ssh_wsl() {
    mkdir -p "${HOME}/.ssh" || return 1
    cp "$files_path/ssh-config" "${HOME}/.ssh/config" || return 1
    sudo chmod 600 "${HOME}/.ssh/config" || return 1
}

generate_ssh_key() {
    # See: https://www.ssh.com/ssh/keygen/
    ssh-keygen -t ed25519 -C "daniel.furman8@gmail.com" || return 1
    eval "$(ssh-agent -s)" || return 1
    ssh-add "${HOME}/.ssh/id_ed25519" || return 1
}

setup_brew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" || return 1
}

install_vscode_plugins() {
    code \
        --install-extension alefragnani.rtf \
        --install-extension BazelBuild.vscode-bazel \
        --install-extension DavidAnson.vscode-markdownlint \
        --install-extension dunstontc.viml \
        --install-extension eamodio.gitlens \
        --install-extension EditorConfig.EditorConfig \
        --install-extension golang.go \
        --install-extension hashicorp.terraform \
        --install-extension johnpapa.vscode-peacock \
        --install-extension mechatroner.rainbow-csv \
        --install-extension ms-azuretools.vscode-docker \
        --install-extension ms-python.python \
        --install-extension ms-python.vscode-pylance \
        --install-extension ms-toolsai.jupyter \
        --install-extension ms-toolsai.jupyter-keymap \
        --install-extension ms-toolsai.jupyter-renderers \
        --install-extension ms-vscode.cpptools \
        --install-extension ms-vscode.powershell \
        --install-extension ms-vscode.references-view \
        --install-extension ms-vscode-remote.remote-containers \
        --install-extension ms-vsliveshare.vsliveshare-pack \
        --install-extension platformio.platformio-ide \
        --install-extension m-zajac.vsc-json2go \
        --install-extension redhat.vscode-yaml \
        --install-extension sourcegraph.sourcegraph \
        --install-extension streetsidesoftware.code-spell-checker \
        --install-extension streetsidesoftware.code-spell-checker-polish \
        --install-extension timonwong.shellcheck \
        --install-extension tomoki1207.pdf \
        --install-extension trond-snekvik.simple-rst \
        --install-extension wholroyd.jinja \
        --install-extension yutengjing.open-in-external-app \
        --install-extension yzane.markdown-pdf \
        --install-extension yzhang.markdown-all-in-one
}

run || exit 1
