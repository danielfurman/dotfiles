#!/usr/bin/env bash
# TODO: make script execution path independent

usage() {
	echo -e "Usage: $(basename "$0") [options]\n"
	echo -e "Install and configure development tools on Ubuntu.\n"
	echo "Options:"
	echo -e "\t--all			=> Install and configure all tools"
	echo -e "\t--bash			=> Configure Bash"
	echo -e "\t--zsh			=> Install and configure ZSH"
	echo -e "\t--tmux			=> Install and configure tmux"
	echo -e "\t--ssh			=> Symlink SSH config"
	echo -e "\t--ssh-wsl		=> Copy SSH config (symlink does not work in WSL)"
	echo -e "\t--ssh-key		=> Generate SSH key"
	echo -e "\t--git			=> Install and configure git"
	echo -e "\t--vscode			=> Install and configure Visual Studio Code"
	echo -e "\t--go				=> Install Go"
	echo -e "\t--docker			=> Install Docker"
	echo -e "\t--help (-h)		=> Show usage"
}

[ $# -eq 0 ] && { usage; exit 1; }

while :; do
	case "$1" in
		--all) all=1; shift;;
		--bash) bash=1; shift;;
		--zsh) zsh=1; shift;;
		--tmux) tmux=1; shift;;
		--ssh) ssh=1; shift;;
		--ssh-wsl) sshwsl=1; shift;;
		--ssh-key) sshkey=1; shift;;
		--git) git=1; shift;;
		--vscode) vscode=1; shift;;
		--go) go=1; shift;;
		--docker) docker=1; shift;;
		-h | --help) usage; exit 0;;
		*) break;;
	esac
done

[ $# -ne 0 ] && { usage; exit 1; }

run() {
	# shellcheck disable=SC2034
	local readonly files_path=$PWD/files

	ensure_tools || return 1

	[[ -v bash || -v all ]] && (setup_bash || return 1)
	[[ -v zsh || -v all ]] && (setup_zsh || return 1)
	[[ -v tmux || -v all ]] && (setup_tmux || return 1)
	[[ -v ssh || -v all ]] && (setup_ssh || return 1)
	[[ -v sshwsl || -v all ]] && (setup_ssh_wsl || return 1)
	[[ -v sshkey || -v all ]] && (generate_ssh_key || return 1)
	[[ -v git || -v all ]] && (setup_git || return 1)
	[[ -v vscode || -v all ]] && (setup_vscode || return 1)
	[[ -v go || -v all ]] && (install_go || return 1)
	[[ -v docker || -v all ]] && (install_docker || return 1)

	return 0
}

ensure_tools() {
	(which curl wget > /dev/null) || sudo apt install -y curl wget || return 1
}

setup_bash() {
	ln -s "$files_path"/.profile_custom.sh ~/.profile_custom.sh || echo "Failed to symlink ~/.profile_custom.sh"

	# TODO: idempotentify text appending
	cat <<-EOF >>~/.profile
	if [ -f ~/.profile_custom.sh ]; then
	  source ~/.profile_custom.sh
	fi
	EOF

	ln -s "$files_path"/.bash_custom.sh ~/.bash_custom.sh || echo "Failed to symlink ~/.bash_custom.sh"

	# TODO: idempotentify text appending
	cat <<-EOT >>~/.bashrc
	if [ -f ~/.bash_custom.sh ]; then
	  source ~/.bash_custom.sh
	fi
	EOT

	# shellcheck disable=SC1090
	source ~/.profile || echo "Failed to source ~/.profile"
	return 1
}

setup_zsh() {
	sudo apt install -y zsh || return 1
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || return 1

	echo "TODO: configure zsh"
}

setup_tmux() {
	sudo apt install -y tmux || return 1
	ln -s "$files_path"/.tmux.conf ~/.tmux.conf || echo "Failed to symlink ~/.tmux.conf"
}

setup_ssh() {
	mkdir -p ~/.ssh && ln -s "$files_path"/config ~/.ssh/config || echo "Failed to symlink ~/.ssh/config"
}

setup_ssh_wsl() {
	mkdir -p ~/.ssh && cp "$files_path"/config ~/.ssh/config || echo "Failed to copy ~/.ssh/config"
	sudo chmod 600 ~/.ssh/config || echo "Failed to 'chmod 600 ~/.ssh/config'"
	echo "AddKeysToAgent yes" >> ~/.ssh/config || echo "Failed to add 'AddKeysToAgent yes' to ~/.ssh/config"
}

generate_ssh_key() {
	ssh-keygen -t rsa -b 4096 -C "daniel.furman8@gmail.com" || return 1
	eval "$(ssh-agent -s)" || return 1
	ssh-add ~/.ssh/id_rsa || echo "Failed to 'ssh-add ~/.ssh/id_rsa'"
}

setup_git() {
	sudo apt install -y git || return 1
	ln -s "$files_path"/.gitconfig ~/.gitconfig || echo "Failed to symlink ~/.gitconfig"
	ln -s "$files_path"/.gitignore_global ~/.gitignore_global || echo "Failed to symlink ~/.gitignore_global"
	cp "$files_path"/.gitconfig_local ~/.gitconfig_local || echo "Failed to copy .gitconfig_local to ~/.gitconfig_local"
}

setup_vscode() {
	echo "TODO: install VS Code"

	ln -s "$files_path"/vscode/settings.json ~/.config/Code/User/settings.json || echo "Failed to symlink ~/.config/Code/User/settings.json"
}

install_go () {
	sudo rm -rf /usr/local/go/ || return 1
	wget -qO- https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz | sudo tar -xz -C /usr/local || return 1
}

install_docker() {
	echo "TODO: install_docker and configure it"
	return 1
}

run || exit 1
