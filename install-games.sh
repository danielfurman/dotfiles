#!/usr/bin/env bash

usage() {
	echo -e "Usage: $(basename "$0") [options]\n"
	echo -e "Install and configure games on Ubuntu.\n"
	echo "Options:"
	echo -e "\t--cs16			=> Configure CS 1.6"
	echo -e "\t--et32			=> Install and configure 32-bit ET:Legacy client"
	echo -e "\t--et64			=> Install and configure 64-bit ET:Legacy client"
	echo -e "\t--et-setup-only	=> Configure ET:Legacy client"
	echo -e "\t--et-server		=> Configure ET:Legacy server"
	echo -e "\t--help (-h)		=> Show usage"
}

[ $# -eq 0 ] && { usage; exit 1; }

while :; do
	case "$1" in
		--cs16) cs16=1; shift;;
		--et32) et32=1; shift;;
		--et64) et64=1; shift;;
		--et-setup-only) et_setup_only=1; shift;;
		--et-server) et_server=1; shift;;
		-h | --help) usage; exit 0;;
		*) break;;
	esac
done

[ $# -ne 0 ] && { usage; exit 1; }

dotfiles_path=$PWD

run() {
	ensure_tools || return 1

	[[ -v cs16 ]] && (setup_cs16 || return 1)
	[[ -v et32 ]] && (install_et32 && setup_et_client || return 1)
	[[ -v et64 ]] && (install_et64 && setup_et_client || return 1)
	[[ -v et_setup_only ]] && (setup_et_client || return 1)
	[[ -v et_server ]] && (setup_et_server || return 1)

	return 0
}

ensure_tools() {
	(which curl wget > /dev/null) || sudo apt install -y curl wget || return 1
}

setup_cs16() {
	ln -sf "$dotfiles_path/files/games/cs16/userconfig.cfg" ~/.steam/steam/steamapps/common/Half-Life/cstrike/ || return 1
}

install_et32() {
	mkdir -p ~/opt && cd ~/opt && \
		wget -O etlegacy-i386.sh https://www.etlegacy.com/download/file/84 && \
		chmod +x ./etlegacy-i386.sh && \
		./etlegacy-i386.sh && \
		rm ./etlegacy-i386.sh || return 1

	sudo dpkg --add-architecture i386 && \
		sudo apt update && \
		sudo apt install -y g++-multilib libc6:i386 libdrm2:i386 libexpat1:i386 libgcc1:i386 libgl1-mesa-glx:i386 \
			libglapi-mesa:i386 libglu1-mesa:i386 libstdc++6:i386 libx11-6:i386 libx11-xcb1:i386 libxau6:i386 \
			libxcb1:i386 libxcb-dri2-0:i386 libxcb-dri3-0:i386 libxcb-glx0:i386 libxcb-present0:i386 \
			libxcb-sync1:i386 libxdamage1:i386 libxdmcp6:i386 libxext6:i386 libxfixes3:i386 libxshmfence1:i386 \
			libxxf86vm1:i386 libasound2:i386 libasound2-plugins:i386 || return 1
}

install_et64() {
	mkdir -p ~/opt && cd ~/opt && \
		wget -O etlegacy-x86_64.sh https://www.etlegacy.com/download/file/86 && \
		chmod +x ./etlegacy-x86_64.sh && \
		./etlegacy-x86_64.sh && \
		rm ./etlegacy-x86_64.sh || return 1
}

setup_et_client() {
	ln -sf "$dotfiles_path/files/games/et/autoexec.cfg" ~/.etlegacy/etmain/
}

setup_et_server() {
	local readonly et_server_src=$GAMES_PATH/et/server
	local readonly et_dest=~/.etlegacy

	ln -sf "$et_server_src/etl_server.cfg" $et_dest/etmain/ || return 1
	ln -sf "$et_server_src/legacy.cfg" $et_dest/etmain/ || return 1

	local readonly et_server_files="etl_server.cfg legacy.cfg campaigncycle.cfg lmscycle.cfg mapvotecycle.cfg \
		objectivecycle.cfg punkbuster.cfg stopwatchcycle.cfg"
	for f in $et_server_files; do
		ln -sf "$et_server_src/$f" $et_dest/etmain/
	done
}

run || exit 1
