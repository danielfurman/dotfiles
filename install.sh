#!/usr/bin/env bash
# Install and configure development tools.
# Symlink failures do not terminate script.
# TODO: use if; then; fi where possible
# TODO: make script execution path independent

usage() {
    echo -e "Usage: $(basename "$0") [options]\n"
    echo -e "Install and configure development tools on Linux.\n"
    echo "Options:"
    echo -e "\t--all        => Install and configure all tools"
    echo -e "\t--shell      => Configure shell"
    echo -e "\t--ssh-wsl    => Copy SSH config (symlink does not work in WSL)"
    echo -e "\t--ssh-key    => Generate SSH key"
    echo -e "\t--go         => Install Go"
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
        --go) go=1; shift;;
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
    [[ -v go || -v all ]] && (setup_go || return 1)
    [[ -v vscode || -v all ]] && (install_vscode_plugins || return 1)

    return 0
}

ensure_tools() {
    command -v curl git wget ||
        sudo pacman -S curl git wget ||
        sudo apt install -y curl git wget ||
        brew install curl git wget ||
        return 1
}

setup_shell() {
    # TODO: idempotentify text appending
    # shellcheck disable=SC2016
    {
        echo 'if [ -r "${HOME}/.profile" ]; then source "${HOME}/.profile"; fi' >> "${HOME}/.bash_profile"
        echo 'case "$-" in *i*) if [ -r "${HOME}/.bashrc" ]; then source "${HOME}/.bashrc"; fi;; esac' >> "${HOME}/.bash_profile"
        echo 'if [ -r "${HOME}/.env.sh" ]; then source "${HOME}/.env.sh"; fi' >> "${HOME}/.profile"
        echo 'if [ -r "${HOME}/.shrc.sh" ]; then source "${HOME}/.shrc.sh"; fi' >> "${HOME}/.bashrc"

        echo 'if [ -r "${HOME}/.env.sh" ]; then source "${HOME}/.env.sh"; fi' >> "${HOME}/.zprofile"
        echo 'if [ -r "${HOME}/.shrc.sh" ]; then source "${HOME}/.shrc.sh"; fi' >> "${HOME}/.zshrc"
    }

    $symlink "$files_path/.env.sh" "${HOME}/.env.sh"
    $symlink "$files_path/.shrc.sh" "${HOME}/.shrc.sh"

    $symlink "$files_path/.gitconfig" "${HOME}/.gitconfig"
    cp -n "$files_path/.gitconfig_local" "${HOME}/.gitconfig_local"
    $symlink "$files_path/.gitignore_global" "${HOME}/.gitignore_global"
    mkdir -p "${HOME}/.ssh"
    $symlink "$files_path/config" "${HOME}/.ssh/config"
    $symlink "$files_path/.tmux.conf" "${HOME}/.tmux.conf"
    $symlink "$files_path/.vimrc" "$HOME/.vimrc"
    $symlink "$files_path/scripts" "${HOME}/"

    if [ "$(uname)" == 'Darwin' ]; then
        $symlink "$files_path/vscode.json" "$HOME/Library/Application Support/Code/User/settings.json"
    else
        $symlink "$files_path/vscode.json" "$HOME/.config/Code - OSS/User/settings.json"
    fi

    # shellcheck disable=SC1090
    source "${HOME}/.profile" || echo "Failed to source ${HOME}/.profile"

    if command -v pacman; then
        sudo pkgfile -u || return 1
    fi

    # It does not exit
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || return 1
}

setup_ssh_wsl() {
    mkdir -p "${HOME}/.ssh" || return 1
    cp "$files_path/config" "${HOME}/.ssh/config" || return 1
    sudo chmod 600 "${HOME}/.ssh/config" || return 1
    echo "AddKeysToAgent yes" >> "${HOME}/.ssh/config" || return 1 # TODO: idempotify
}

generate_ssh_key() {
    ssh-keygen -t rsa -b 4096 -C "daniel.furman8@gmail.com" || return 1
    eval "$(ssh-agent -s)" || return 1
    ssh-add "${HOME}/.ssh/id_rsa" || return 1
}

setup_brew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" || return 1
}

setup_go() {
    # Uncomment if needed
    # sudo rm -rf /usr/local/go/ || return 1
    # wget -O- https://dl.google.com/go/go1.14.linux-amd64.tar.gz | sudo tar -xz -C /usr/local || return 1

    go get -u -v github.com/posener/complete/gocomplete && gocomplete -install || return 1
    go get -u -v github.com/mingrammer/gosearch || return 1
}

install_vscode_plugins() {
    code --install-extension alefragnani.rtf \
        --install-extension BazelBuild.vscode-bazel \
        --install-extension DavidAnson.vscode-markdownlint \
        --install-extension dunstontc.viml \
        --install-extension eamodio.gitlens \
        --install-extension EditorConfig.EditorConfig \
        --install-extension johnpapa.vscode-peacock \
        --install-extension karigari.chat \
        --install-extension lextudio.restructuredtext \
        --install-extension ms-azuretools.vscode-docker \
        --install-extension ms-python.python \
        --install-extension ms-vscode.cpptools \
        --install-extension ms-vscode.Go \
        --install-extension ms-vscode.powershell \
        --install-extension ms-vsliveshare.vsliveshare \
        --install-extension ms-vsliveshare.vsliveshare-audio \
        --install-extension ms-vsliveshare.vsliveshare-pack \
        --install-extension redhat.vscode-yaml \
        --install-extension sourcegraph.sourcegraph \
        --install-extension streetsidesoftware.code-spell-checker \
        --install-extension streetsidesoftware.code-spell-checker-polish \
        --install-extension timonwong.shellcheck \
        --install-extension wholroyd.jinja \
        --install-extension yzhang.markdown-all-in-one \
        --install-extension zhouronghui.propertylist
}

run || exit 1
