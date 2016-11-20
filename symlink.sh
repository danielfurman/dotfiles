#!/usr/bin/env bash
# Symlink configuration files on Linux system

COMMON_FILES=".bashrc .gitconfig .gitignore_global .profile"
EXTRA_FILES=".gitconfig_local .profile_local"

if [ -z "$DOTFILES_PATH" ]; then
	DOTFILES_PATH=$HOME/dropbox/dotfiles
fi
FILES_PATH=$DOTFILES_PATH/files

if [ -v COMMON ]; then
	echo "Creating symbolic links to common configs"
	for f in $COMMON_FILES; do
		ln -s $OPTS $FILES_PATH/$f $HOME/$f
	done
fi

if [ -v EXTRA ]; then
	echo "Creating symbolic link to extra configs"
	for f in $EXTRA_FILES; do
		ln -s $OPTS $FILES_PATH/$f $HOME/$f
	done

	mkdir -p $HOME/.ssh
	ln -s $OPTS $FILES_PATH/config $HOME/.ssh/config
fi

if [ -v SUBLIME ]; then
	echo "Creating symbolic links to SublimeText3 configs"
	SUBLIME_SRC=$DOTFILES_PATH/sublime-text-3
	SUBLIME_DEST=$HOME/.config/sublime-text-3

	ln -s $OPTS $SUBLIME_SRC/Installed\ Packages $SUBLIME_DEST/
	ln -s $OPTS $SUBLIME_SRC/Packages $SUBLIME_DEST/
fi
