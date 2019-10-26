#!/usr/bin/env bash
# Install and configure games on Linux.
# Symlink failures do not terminate script.

usage() {
	echo -e "Usage: $(basename "$0") [options]\n"
	echo -e "Install and configure games on Linux.\n"
	echo "Options:"
	echo -e "\t--cs16			=> Configure CS 1.6"
	echo -e "\t--csgo			=> Configure CS: GO"
	echo -e "\t--et32			=> Install and configure 32-bit ET:Legacy client"
	echo -e "\t--et64			=> Install and configure 64-bit ET:Legacy client"
	echo -e "\t--et-setup-only	=> Configure ET:Legacy client"
	echo -e "\t--et-server		=> Configure ET:Legacy server"
	echo -e "\t--force			=> Force symlink create"
	echo -e "\t--help (-h)		=> Show usage"
}

[ $# -eq 0 ] && { usage; exit 1; }

while :; do
	case "$1" in
		--cs16) cs16=1; shift;;
		--csgo) csgo=1; shift;;
		--et32) et32=1; shift;;
		--et64) et64=1; shift;;
		--et-setup-only) et_setup_only=1; shift;;
		--et-server) et_server=1; shift;;
		--force) force_symlink=1; shift;;
		-h | --help) usage; exit 0;;
		*) break;;
	esac
done

[ $# -ne 0 ] && { usage; exit 1; }

run() {
	# shellcheck disable=SC2034
	local readonly files_path=$PWD/files

	symlink="ln -s"
	[[ -v force_symlink ]] && symlink="ln -sf"

	ensure_tools || return 1

	[[ -v cs16 ]] && (setup_cs16 || return 1)
	[[ -v csgo ]] && (setup_csgo || return 1)
	[[ -v et32 ]] && (install_et32 && setup_et_client || return 1)
	[[ -v et64 ]] && (install_et64 && setup_et_client || return 1)
	[[ -v et_setup_only ]] && (setup_et_client || return 1)
	[[ -v et_server ]] && (setup_et_server || return 1)
}

ensure_tools() {
	command -v curl wget || sudo pacman -S curl wget || sudo apt install -y curl wget || return 1
}

setup_cs16() {
	$symlink "$files_path/games/cs16/userconfig.cfg" ~/.steam/steam/steamapps/common/Half-Life/cstrike/
}

setup_csgo() {
	# Alternatively "$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/csgo"
	$symlink "$files_path/games/csgo/autoexec.cfg" ~/.steam/steam/userdata/28059286/730/remote/cfg/
	$symlink "$files_path/games/csgo/bots.cfg" ~/.steam/steam/userdata/28059286/730/remote/cfg/
	$symlink "$files_path/games/csgo/practice.cfg" ~/.steam/steam/userdata/28059286/730/remote/cfg/
	$symlink "$files_path/games/csgo/video.txt" ~/.steam/steam/userdata/28059286/730/local/cfg/
}

install_et32() {
	mkdir -p ~/opt && cd ~/opt && \
		wget -O etlegacy-i386.sh https://www.etlegacy.com/download/platform/lnx && \
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
		wget -O etlegacy-x86_64.sh https://www.etlegacy.com/download/file/127 && \
		chmod +x ./etlegacy-x86_64.sh && \
		./etlegacy-x86_64.sh && \
		rm ./etlegacy-x86_64.sh || return 1
}

setup_et_client() {
	$symlink "$files_path/games/et/autoexec.cfg" ~/.etlegacy/etmain/
}

setup_et_server() {
	# shellcheck disable=SC2034
	local readonly et_server_files="etl_server.cfg legacy.cfg campaigncycle.cfg lmscycle.cfg mapvotecycle.cfg \
		objectivecycle.cfg punkbuster.cfg stopwatchcycle.cfg"
	for f in $et_server_files; do
		$symlink "$files_path/games/et/server/$f" ~/.etlegacy/etmain/
	done
}

run || exit 1
