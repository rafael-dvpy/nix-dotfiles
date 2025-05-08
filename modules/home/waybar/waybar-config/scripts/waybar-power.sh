#!/usr/bin/env bash
# Display a power menu using wofi and execute the selected action
options="Poweroff\nReboot\nSuspend\nLogout"
choice=$(echo -e "$options" | wofi --show dmenu --style=$HOME/.config/wofi.css --term=foot --prompt="Power Menu")
case "$choice" in
  Poweroff) systemctl poweroff ;;
  Reboot) systemctl reboot ;;
  Suspend) systemctl suspend ;;
  Logout) hyprctl dispatch exit ;;
  *) exit 1 ;;
esac
