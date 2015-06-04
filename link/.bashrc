# github.com/rafi ~/.bashrc config

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# https://wiki.archlinux.org/index.php/RTorrent
# Ctrl-s is often used for terminal control to stop screen output while Ctrl-q is used to
# start it. These mappings may interfere with rTorrent. Check to see if these terminal
# options are bound to a mapping:
#   $ stty -a
# Remove the ^S ^Q mappings
stty stop undef
stty start undef

# Bash options
shopt -s cdspell        # autocorrects cd misspellings
shopt -s checkwinsize   # update the value of LINES and COLUMNS after each command if altered
shopt -s cmdhist        # save multi-line commands in history as single line
shopt -s dotglob        # include dotfiles in pathname expansion
shopt -s expand_aliases # expand aliases
shopt -s extglob        # enable extended pattern-matching features
shopt -s histreedit     # Add failed commands to the bash history
shopt -s histappend     # Append each session's history to $HISTFILE
shopt -s autocd         # Autocd

export HISTSIZE=2000
export HISTFILESIZE=50000
export HISTFILE="$XDG_CACHE_HOME/bash_history"
export HISTCONTROL=ignoreboth
export VISUAL=vim
export EDITOR="$VISUAL"
export PAGER=less

source "$XDG_CONFIG_HOME/bash/aliases"

# Source all extra functions
for f in $XDG_CONFIG_HOME/bash/functions.d/*; do source "$f"; done

if [[ "$OSTYPE" == "darwin"* ]]; then
	# OSX GNU bash-completion
	if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
		source /opt/local/etc/profile.d/bash_completion.sh
	fi
	# Edit the /opt/X11/lib/X11/fontconfig/fonts.conf and added the directory
	# "/Library/Fonts" to the font directory list
#	export FONTCONFIG_PATH=/opt/X11/lib/X11/fontconfig
fi

# Git prompt helpers
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWCOLORHINTS=0
if [ -d $PREFIX/share/git/completion ]; then
	source $PREFIX/share/git/completion/git-prompt.sh
#	source $PREFIX/share/git/contrib/completion/git-completion.bash
fi

# If this is an xterm/rxvt/screen/tmux set the window title to user@host:dir
case "$TERM" in
xterm*|rxvt*|screen*)
	# Show a "user@host: /dir" in terminal title
	PROMPT_COMMAND='history -a; echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
	;;
*)
	;;
esac

# Load a command prompt theme
source $XDG_CONFIG_HOME/bash/themes/current

# Load directory and file colors
eval $(dircolors -b "$XDG_CONFIG_HOME/bash/dircolors")

# vim: set ts=2 sw=2 tw=80 noet :
