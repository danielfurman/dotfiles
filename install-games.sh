#!/usr/bin/env bash
# Install and configure games on Linux.
# Symlink failures do not terminate script. Needs to be executed from script directory.

usage() {
	echo -e "Usage: $(basename "$0") [options]\n"
	echo -e "Install and configure games on Linux.\n"
	echo "Options:"
	echo -e "\t--cs				=> Configure CS 2"
	echo -e "\t--cs16			=> Configure CS 1.6"
	echo -e "\t--et-client		=> Configure ET:Legacy client"
	echo -e "\t--et-server		=> Configure ET:Legacy server"
	echo -e "\t--force			=> Force symlink create"
	echo -e "\t--help (-h)		=> Show usage"
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

while :; do
	case "$1" in
		--cs16) cs16=1; shift;;
		--cs) cs=1; shift;;
		--et-setup) et_client=1; shift;;
		--et-server) et_server=1; shift;;
		--force) force_symlink=1; shift;;
		-h | --help) usage; exit 0;;
		*) break;;
	esac
done

run() {
	# shellcheck disable=SC2034
	declare -r files_path=$PWD/files # symlinks require full paths

	symlink="ln -sv"
	[[ -v force_symlink ]] && symlink="ln -sf"

	[[ -v cs16 ]] && setup_cs16
	[[ -v cs ]] && setup_cs
	[[ -v et_client ]] && setup_et_client
	[[ -v et_server ]] && setup_et_server
}

setup_cs16() {
	$symlink "$files_path/games/cs16/userconfig.cfg" ~/.steam/steam/steamapps/common/Half-Life/cstrike/
}

setup_cs() {
	# Alternatively "$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/cs"
	$symlink "$files_path/games/cs/autoexec.cfg" ~/.steam/steam/userdata/28059286/730/remote/cfg/
	$symlink "$files_path/games/cs/bots.cfg" ~/.steam/steam/userdata/28059286/730/remote/cfg/
	$symlink "$files_path/games/cs/practice.cfg" ~/.steam/steam/userdata/28059286/730/remote/cfg/
	$symlink "$files_path/games/cs/video.txt" ~/.steam/steam/userdata/28059286/730/local/cfg/
}

setup_et_client() {
	$symlink "$files_path/games/et/autoexec.cfg" ~/.etlegacy/etmain/
}

setup_et_server() {
	# shellcheck disable=SC2034
	declare -r et_server_files="etl_server.cfg legacy.cfg campaigncycle.cfg lmscycle.cfg mapvotecycle.cfg \
		objectivecycle.cfg punkbuster.cfg stopwatchcycle.cfg"
	for f in $et_server_files; do
		$symlink "$files_path/games/et/server/$f" ~/.etlegacy/etmain/
	done
}

run
