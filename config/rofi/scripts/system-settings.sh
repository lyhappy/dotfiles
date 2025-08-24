#!/bin/bash

declare options=("桌面背景 —— nitrogen
音频设备管理 —— pavucontrol
文件管理器 —— nautilus
文件管理器 —— thunar
输入法管理 —— fcitx5-configtool
sysprof —— sysprof
进程与服务管理器 —— stacer
独显设置 —— nvidia-settings
quit")

# choice=$(echo -e "${options[@]}" | dmenu -fn "WenQuanYi Zen Hei-24" -i -l 10 -p 'tool list: ')
choice=$(echo -e "${options[@]}" | rofi -dmenu -p 'tool list: ')

if [[ "$choice" == "quit" ]]; then
    echo "Program terminated." && exit 1
elif [ "$choice" ]; then
    tool=$(printf '%s\n' "${choice}" | awk '{print $NF}')
    echo $tool
    exec $tool
else
    echo "Program terminated." && exit 1
fi

