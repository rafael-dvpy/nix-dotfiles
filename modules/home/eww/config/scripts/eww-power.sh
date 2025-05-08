#!/usr/bin/env bash
# Execute power menu actions
case "$1" in
  poweroff) systemctl poweroff ;;
  reboot) systemctl reboot ;;
  suspend) systemctl suspend ;;
  logout) hyprctl dispatch exit ;;
  *) exit 1 ;;
esac
