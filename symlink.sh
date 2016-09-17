#!/usr/bin/env bash
# Symlink configuration files on Linux system

COMMON_FILES=".bashrc .gitconfig .gitignore_global .profile"
EXTRA_FILES=".gitconfig_local .profile_local"

if [ -z "$DOTFILES_PATH" ]; then
	DOTFILES_PATH=$HOME/dropbox/dotfiles
fi
FILES_PATH=$DOTFILES_PATH/files

echo "Creating symbolic links to common configuration files"
for f in $COMMON_FILES; do
	ln -s $OPTS $FILES_PATH/$f $HOME/$f
done

if [ -v EXTRA ]; then
	echo "Creating symbolic link to extra configuration files"
	for f in $EXTRA_FILES; do
		ln -s $OPTS $FILES_PATH/$f $HOME/$f
	done

	ln -s $OPTS $FILES_PATH/config $HOME/.ssh/config
fi
