#!/bin/bash
#  ____ _____
# |  _ \_   _|  Derek Taylor (DistroTube)
# | | | || |    http://www.youtube.com/c/DistroTube
# | |_| || |    http://www.gitlab.com/dwt1/
# |____/ |_|
#
# Dmenu script for editing some of my more frequently edited config files.


declare options=("alacritty
bash
conky
emacs.d/init.el
greenclip
kitty
neovim
picom
polybar
qtile
vifm
vim
xresources
xprofile
zsh
quit")

choice=$(echo -e "${options[@]}" | rofi -dmenu -l 10 -p 'Edit config file: ')

case "$choice" in
	quit)
		echo "Program terminated." && exit 1
	;;
	alacritty)
		choice="$HOME/.config/alacritty/alacritty.yml"
	;;
	bash)
		choice="$HOME/.bashrc"
	;;
    conky)
        choice="$HOME/.config/conky/conky.conf"
    ;;
	emacs.d/init.el)
		choice="$HOME/.emacs.d/init.el"
	;;
    greenclip)
        choice="$HOME/.config/greenclip.toml"
    ;;
    kitty)
        choice="$HOME/.config/kitty/kitty.conf"
    ;;
	neovim)
		choice="$HOME/.config/nvim/init.lua"
	;;
	picom)
		choice="$HOME/.config/picom/picom.conf"
	;;
	polybar)
		choice="$HOME/.config/polybar/config"
	;;
	qtile)
		choice="$HOME/.config/qtile/config.py"
	;;
	vifm)
		choice="$HOME/.config/vifm/vifmrc"
	;;
	vim)
		choice="$HOME/.vimrc"
	;;
	xresources)
		choice="$HOME/.Xresources"
	;;
	xprofile)
		choice="$HOME/.xprofile"
	;;
	zsh)
		choice="$HOME/.zshrc"
	;;
	*)
		exit 1
	;;
esac
kitty -e nvim "$choice"
