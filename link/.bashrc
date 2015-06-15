# Do nothing if we're not in an interactive session
[[ "$PS1" ]] || return

# Show a message on any errors
#trap 'trap_error' ERR

misc_config=( $HOME/.config/bash/* )
misc_path=( "$HOME/.config/alternatives" "$HOME/bin" "$HOME/.local/bin" )

# Source vte-specific config
[[ "$TERM" == 'xterm-termite' && -f '/etc/profile.d/vte.sh' ]] && {
	source /etc/profile.d/vte.sh
}

# Source external configs
for i in "${misc_config[@]}"; do
	source "$i" || { err "Failed to source $i!"; }
done

# Add custom PATH entries
for i in "${misc_path[@]}"; do
	[[ -d "$i" ]] && { MISCPATH+="$i:"; }
done
export PATH="${MISCPATH}${PATH}"

# BASH options
bash_opts=(
	'checkwinsize' 'histappend' 'autocd'
	'checkhash'
)
shopt -s "${bash_opts[@]}"
shopt -u sourcepath

PROMPT_COMMAND='set_prompt'

HISTCONTROL="$HISTCONTROL${HISTCONTROL+,}ignoredups"
HISTCONTROL='ignoreboth'

# Environment
export LC_ALL='en_US.UTF-8'
export EDITOR='vim'

#export TERM='xterm-256color'
export COLORTERM='xterm-256color'

# Specific to this setup
alias dotfiles_pull='git -C ~/.dotfiles pull'
alias dotfiles_push='git -C ~/.dotfiles commit -a; git -C ~/.dotfiles push'

cfg_newsh_default_shebang='#!/usr/bin/env bash'
