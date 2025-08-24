#!/bin/bash
#  ____ _____
# |  _ \_   _|  Derek Taylor (DistroTube)
# | | | || |    http://www.youtube.com/c/DistroTube
# | |_| || |    http://www.gitlab.com/dwt1/
# |____/ |_|
#
# Dmenu script for launching system monitoring programs.


declare -a options=("bashtop
glances
gtop
htop
iftop
iotop
iptraf-ng
nmon
s-tui
quit")

choice=$(echo -e "${options[@]}" | rofi -dmenu -p 'System monitors: ')

case $choice in
	quit)
		echo "Program terminated." && exit 1
	;;
	bashtop| \
	glances| \
	gtop| \
	htop| \
	nmon| \
	s-tui)
        exec kitty -e $choice
	;;
	iftop| \
	iotop| \
	iptraf-ng)
        exec kitty -e gksu $choice
	;;
	*)
		exit 1
	;;
esac

