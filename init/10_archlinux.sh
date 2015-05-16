# Arch-only stuff. Abort if not Arch.
is_archlinux || return 1

e_header "Updating PACMAN"
sudo pacman -Syu
sudo pacman -S awesome mc subversion git emacs

git clone https://github.com/syl20bnr/spacemacs.git ~/.emacs.d