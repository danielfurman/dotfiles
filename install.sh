#!/usr/bin/env bash
# Install and configure development tools on Linux.
# Symlink failures do not terminate script.
# TODO: use if; then; fi where possible
# TODO: make script execution path independent

usage() {
	echo -e "Usage: $(basename "$0") [options]\n"
	echo -e "Install and configure development tools on Linux.\n"
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
	echo -e "\t--force			=> Force symlink create"
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

	symlink="ln -s"
	[[ -v force_symlink ]] && symlink="ln -sf"

	[[ -v bash || -v all ]] && (setup_bash || return 1)
	[[ -v zsh || -v all ]] && (setup_zsh || return 1)
	[[ -v tmux || -v all ]] && (setup_tmux || return 1)
	[[ -v ssh || -v all ]] && (setup_ssh || return 1)
	[[ -v sshwsl || -v all ]] && (setup_ssh_wsl || return 1)
	[[ -v sshkey || -v all ]] && (generate_ssh_key || return 1)
	[[ -v git || -v all ]] && (setup_git || return 1)
	[[ -v vscode || -v all ]] && (setup_vscode || return 1)
	[[ -v go || -v all ]] && (install_go || return 1)

	return 0
}

ensure_tools() {
	command -v curl wget || sudo pacman -S curl wget || sudo apt install -y curl wget || return 1
}

setup_bash() {
	# TODO: idempotentify text appending
	cat <<-EOF >>~/.bash_profile
	if [[ -r ~/.profile ]]; then
	    source ~/.profile;
	fi
	case "\$-" in *i*)
	    if [[ -r ~/.bashrc ]]; then
	        source ~/.bashrc;
	    fi;;
	esac
	EOF

	# TODO: idempotentify text appending
	cat <<-EOF >>~/.profile
	if [[ -r ~/.profile_custom.sh ]]; then
	    source ~/.profile_custom.sh
	fi
	EOF

	# TODO: idempotentify text appending
	cat <<-EOF >>~/.bashrc
	if [[ -f ~/.bash_custom.sh ]]; then
	    source ~/.bash_custom.sh
	fi
	EOF

	$symlink "$files_path/.profile_custom.sh" ~/.profile_custom.sh
	$symlink "$files_path/.bash_custom.sh" ~/.bash_custom.sh

	# shellcheck disable=SC1090
	source ~/.profile || echo "Failed to source ~/.profile"

	if command -v pacman; then
		sudo pkgfile -u || return 1
	fi
}

setup_zsh() {
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || return 1

	echo "TODO: configure zsh"
}

setup_tmux() {
	$symlink "$files_path/.tmux.conf" ~/.tmux.conf
}

setup_ssh() {
	mkdir -p ~/.ssh && $symlink "$files_path/config" ~/.ssh/config
}

setup_ssh_wsl() {
	mkdir -p ~/.ssh && cp "$files_path/config" ~/.ssh/config || return 1
	sudo chmod 600 ~/.ssh/config || return 1
	echo "AddKeysToAgent yes" >> ~/.ssh/config || return 1 # TODO: idempotify
}

generate_ssh_key() {
	ssh-keygen -t rsa -b 4096 -C "daniel.furman8@gmail.com" || return 1
	eval "$(ssh-agent -s)" || return 1
	ssh-add ~/.ssh/id_rsa || return 1
}

setup_git() {
	$symlink "$files_path/.gitconfig" ~/.gitconfig
	$symlink "$files_path/.gitignore_global" ~/.gitignore_global
	cp "$files_path/.gitconfig_local" ~/.gitconfig_local
}

setup_vscode() {
	$symlink "$files_path/vscode/settings.json" "$HOME/.config/Code - OSS/User/settings.json"
}

install_go() {
	sudo rm -rf /usr/local/go/ || return 1
	wget -O- https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz | sudo tar -xz -C /usr/local || return 1

	go get -u github.com/posener/complete/gocomplete || return 1
	gocomplete -install || return 1
	go get -u github.com/mingrammer/gosearch
}

run || exit 1
