#!/usr/bin/env bash

source "$HOME/.config/bash/exports"

if [[ "$OSTYPE" != "darwin"* ]]; then
	# Import environment on local login
#	[ -n "$XDG_VTNR" ] && systemctl --user import-environment

	# Default systemd to the console target
	target="console"

	# Bring up systemd --user to the specified target
#	systemctl --user start ${target}.target
	unset target
fi

source "$HOME/.bashrc"

# Extra OSX stuff
if [[ "$OSTYPE" == "darwin"* ]]; then
	source "$HOME/.config/bash/osx"
fi

# Use keychain to load keys
# https://github.com/funtoo/keychain
#eval `keychain --dir "$XDG_CACHE_HOME/keychain" --eval --agents ssh -Q --quiet current`

#if [ -n "$IS_SSH" ]; then
#	hash tmux 2>/dev/null && tmux has 2>/dev/null && exec tmux attach
#fi

