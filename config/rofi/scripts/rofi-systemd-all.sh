#!/usr/bin/env bash
# rofi-systemd-all.sh

SERVICE=$(systemctl list-unit-files --type=service \
    | awk 'NR>1 && $1 != "" {print $1}' \
    | rofi -dmenu -p "All services")

[ -z "$SERVICE" ] && exit 0

ACTION=$(echo -e "start\nstop\nrestart\nstatus\nenable\ndisable" \
    | rofi -dmenu -p "Action for $SERVICE")

[ -z "$ACTION" ] && exit 0

sudo -A systemctl "$ACTION" "$SERVICE"

