#!/usr/bin/env bash

usage() {
	echo -e "Usage: $(basename "$0") [-abcdghpz] [--go] [--docker]\n"
	echo -e "Install and configure development tools on Ubuntu.\n"
	echo "Options:"
	echo -e "\t--debug (-d) => Enable debug printing"
	echo -e "\t--all (-a) => Install and configure all tools"
	echo -e "\t--profile (-p) => Symlink .profile"
	echo -e "\t--bash (-b) => Install and configure Bash"
	echo -e "\t--zsh (z) => Install and configure ZSH"
	echo -e "\t--go => Install Go"
	echo -e "\t--chrome (-c) => Install Chrome"
	echo -e "\t--help (-h) => Show usage"
}

[ $# -eq 0 ] && { usage; exit 1; }

while :; do
	case "$1" in
		-d | --debug) debug=1; shift;;
		-a | --all) profile=1; bash=1; zsh=1; go=1; chrome=1; shift;;
		-p | --profile) profile=1; shift;;
		-b | --bash) bash=1; shift;;
		-z | --zsh) zsh=1; shift;;
		-g | --git) git=1; shift;;
		--go) go=1; shift;;
		--docker) docker=1; shift;;
		-c | --chrome) chrome=1; shift;;
		-h | --help) usage; exit 0;;
		*) break;;
	esac
done

[ $# -ne 0 ] && { usage; exit 1; }


run() {
	[ -v debug ] && (set -o xtrace || return 1)

	ensure_tools || return 1

	[ -v profile ] && (setup_profile || return 1)
	[ -v bash ] && (setup_bash || return 1)
	[ -v zsh ] && (setup_zsh || return 1)
	[ -v git ] && (setup_git || return 1)
	[ -v go ] && (install_go || return 1)
	[ -v docker ] && (install_docker || return 1)
	[ -v chrome ] && (install_chrome || return 1)
}

ensure_tools() {
	(which curl wget > /dev/null) || sudo apt install -y curl wget || return 1
}

setup_profile() {
	echo "TODO: setup_profile"
	return 1
}

setup_bash() {
	echo "TODO: setup_bash"
	return 1
}

setup_zsh() {
	sudo apt install -y zsh && \
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || return 1

	echo "TODO: configure zsh"
}

setup_git() {
	echo "TODO: setup_git"
	return 1
}

install_go () {
	wget -qO- https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz | sudo tar -xz -C /usr/local
}

install_docker() {
	echo "TODO: install_docker via snap and configure it"
	return 1
}

install_chrome() {
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
		echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list && \
		sudo apt update && \
		sudo apt install -y google-chrome-stable || return 1
}

run || exit 1
