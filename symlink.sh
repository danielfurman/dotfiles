#!/usr/bin/env bash
# Symlink configuration files on Linux system
# Example usage: COMMON=1 OPTS=-f ./symlink.sh

DOTFILES_PATH=$PWD
FILES_PATH=$DOTFILES_PATH/files
GAMES_PATH=$FILES_PATH/games

if [ -v DEBUG ]; then
	set -x
fi

if [ -v COMMON ]; then
	echo "Creating symbolic links to common configs"
	COMMON_FILES=".bashrc .gitconfig .gitignore_global .profile"
	for f in $COMMON_FILES; do
		ln -s $OPTS $FILES_PATH/$f $HOME/$f
	done
fi

if [ -v EXTRA ]; then
	echo "Creating symbolic link to extra configs"
	EXTRA_FILES=".gitconfig_local .profile_local"
	for f in $EXTRA_FILES; do
		ln -s $OPTS $FILES_PATH/$f $HOME/$f
	done

	ln -s $OPTS $FILES_PATH/config $HOME/.ssh/config
fi

if [ -v SUBLIME ]; then
	echo "Creating symbolic links to Sublime Text 3 configs"
	SUBLIME_SRC=$FILES_PATH/sublime-text-3
	SUBLIME_DEST=$HOME/.config/sublime-text-3

	ln -s $OPTS $SUBLIME_SRC/Installed\ Packages $SUBLIME_DEST/
	ln -s $OPTS $SUBLIME_SRC/Packages $SUBLIME_DEST/
fi

if [ -v VSCODE ]; then
	echo "Creating symbolic links to Visual Studio Code configs"
	VSCODE_SRC=$FILES_PATH/vscode

	ln -s $OPTS $VSCODE_SRC/settings.json $HOME/.config/Code/User/settings.json
	ln -s $OPTS $VSCODE_SRC/extensions $HOME/.vscode/
fi

if [ -v ET ]; then
	echo "Creating symbolic links to ET client configs"
	ET_SRC=$GAMES_PATH/et
	ET_DEST=$HOME/.etlegacy

	ln -s $OPTS $ET_SRC/autoexec.cfg $ET_DEST/etmain/
fi

if [ -v ET_SERVER ]; then
	echo "Creating symbolic links to ET server configs"
	ET_SERVER_SRC=$GAMES_PATH/et/server
	ET_DEST=$HOME/.etlegacy

	ln -s $OPTS $ET_SERVER_SRC/etl_server.cfg $ET_DEST/etmain/
	ln -s $OPTS $ET_SERVER_SRC/legacy.cfg $ET_DEST/etmain/

	ET_SERVER_FILES="etl_server.cfg legacy.cfg campaigncycle.cfg lmscycle.cfg mapvotecycle.cfg \
		objectivecycle.cfg punkbuster.cfg stopwatchcycle.cfg"
	for f in $ET_SERVER_FILES; do
		ln -s $OPTS $ET_SERVER_SRC/$f $ET_DEST/etmain/
	done
fi
