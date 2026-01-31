#!/usr/bin/env bash
pkill -u "$USER" rofi && exit 0

hint-hyprland --format rofi | rofi -dmenu -theme-str 'listview { columns: 1; }' -display-columns 1 -display-column-separator ":::"
