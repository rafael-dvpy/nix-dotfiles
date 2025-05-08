#!/usr/bin/env bash
wofi --show run --style=$HOME/.config/wofi.css --term=foot --prompt="Power Menu" -e "Poweroff:Reboot:Suspend:Logout" | {
  read -r cmd
  case "$cmd" in
    Poweroff) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Suspend) systemctl suspend ;;
    Logout) hyprctl dispatch exit ;;
  esac
}
