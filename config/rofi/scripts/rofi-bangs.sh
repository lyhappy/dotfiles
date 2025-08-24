#!/usr/bin/env bash
# author: unknown
# sentby: MoreChannelNoise (https://www.youtube.com/user/MoreChannelNoise)
# editby: gotbletu (https://www.youtube.com/user/gotbletu)

# demo: https://www.youtube.com/watch?v=kxJClZIXSnM
# info: this is a script to launch other rofi scripts,
#       saves us the trouble of binding multiple hotkeys for each script,
#       when we can just use one hotkey for everything.
# playlist: https://www.youtube.com/playlist?list=PLqv94xWU9zZ0LVP1SEFQsLEYjZC_SUB3m

declare -A LABELS
declare -A COMMANDS

###
# List of defined 'bangs'

# launch programs
# COMMANDS["apps"]="rofi -show drun -show-icons -modi drun"
COMMANDS["apps"]="rofi -show drun -show -modi drun"
LABELS["apps"]=""

# menu for editing tools' configs
COMMANDS["edit-configs"]="$HOME/.config/rofi/scripts/edit-configs.sh"
LABELS["edit-configs"]=""


COMMANDS["power-menu"]="$HOME/.config/rofi/scripts/rofi-powermenu.sh"
LABELS["power-menu"]=""

# greenclip clipboard history
# source: https://github.com/erebe/greenclip
COMMANDS["clipboard"]='rofi -modi "clipboard:greenclip print" -show clipboard'
LABELS["clipboard"]=""

COMMANDS["theme"]='rofi-theme-selector'
LABELS["theme"]=""

# COMMANDS["#screenshot"]='/home/dka/bin/screenshot-scripts/myscreenshot.sh'
# LABELS["#screenshot"]="screenshot"

################################################################################
# do not edit below
################################################################################
##
# Generate menu
##
function print_menu()
{
    for key in ${!LABELS[@]}
    do
  echo "$key    ${LABELS}"
     #   echo "$key    ${LABELS[$key]}"
     # my top version just shows the first field in labels row, not two words side by side
    done
}
##
# Show rofi.
##
function start()
{
    # print_menu | rofi -dmenu -p "?=>"
    print_menu | sort | rofi -dmenu -mesg ">>> launch your collection of rofi scripts" -i -p "rofi-bangs: "

}


# Run it
value="$(start)"

# Split input.
# grab upto first space.
choice=${value%%\ *}
# graph remainder, minus space.
input=${value:$((${#choice}+1))}

##
# Cancelled? bail out
##
if test -z ${choice}
then
    exit
fi

# check if choice exists
if test ${COMMANDS[$choice]+isset}
then
    # Execute the choice
    eval echo "Executing: ${COMMANDS[$choice]}"
    eval ${COMMANDS[$choice]}
else
 eval  $choice | rofi
 # prefer my above so I can use this same script to also launch apps like geany or leafpad etc (DK)
 #   echo "Unknown command: ${choice}" | rofi -dmenu -p "error"
fi

