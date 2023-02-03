if [ -r "~/.profile" ]; then source "~/.profile"; fi
case "$-" in *i*) if [ -r "~/.bashrc" ]; then source "~/.bashrc"; fi;; esac
