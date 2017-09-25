#!/usr/bin/env bash
# Symlink configuration files on Linux system

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

	mkdir -p $HOME/.ssh
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
	ET_SRC=$GAMES_PATH/etlegacy
	ET_DEST=$HOME/.etlegacy

	mkdir -p $ET_DEST/legacy/profiles/Fenthick/
	ln -s $OPTS $ET_SRC/autoexec.cfg $ET_DEST/legacy/profiles/Fenthick/
	ln -s $OPTS $ET_SRC/legacy/etconfig.cfg $ET_DEST/legacy/profiles/Fenthick/
fi

ET_SERVER_FILES="campaigncycle.cfg  etl_server.cfg  legacy.cfg  lmscycle.cfg  mapvotecycle.cfg  objectivecycle.cfg  punkbuster.cfg  server.cfg  stopwatchcycle.cfg"

if [ -v ET_SERVER32 ]; then
	echo "Creating symbolic links to ET server 32-bit configs"
	for f in $ET_SERVER_FILES; do
		ln -s $OPTS $GAMES_PATH/etlegacy/etmain/$f $HOME/opt/etlegacy-v2.75-i386/etmain/
	done
fi

if [ -v ET_SERVER64 ]; then
	echo "Creating symbolic links to ET server 64-bit configs"
	for f in $ET_SERVER_FILES; do
		ln -s $OPTS $GAMES_PATH/etlegacy/etmain/$f $HOME/opt/etlegacy-v2.75-x86_64/etmain/
	done
fi
