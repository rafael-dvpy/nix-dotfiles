{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.waybar;
in
{
  options.modules.waybar = { enable = mkEnableOption "waybar"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      waybar
      font-awesome # For icons
      bash # For custom scripts
      playerctl # For MPRIS module
      networkmanagerapplet # For network module
      pavucontrol # For pulseaudio module
    ];

    home.file = {
      ".config/waybar/config" = {
        text = /*json*/''
          {
            "layer": "top",
            "position": "top",
            "height": 32,
            "spacing": 4,
            "modules-left": ["hyprland/workspaces", "hyprland/window"],
            "modules-center": ["clock"],
            "modules-right": ["network", "pulseaudio", "cpu", "memory", "battery", "mpris", "custom/date", "custom/power", "tray"],
            "hyprland/workspaces": {
              "format": "{name}",
              "on-click": "activate",
              "sort-by-number": true,
              "persistent-workspaces": {
                "*": 5
              }
            },
            "hyprland/window": {
              "format": "{title}",
              "max-length": 50
            },
            "clock": {
              "format": "󰅐 {:%H:%M %d/%m/%Y}",
              "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
              "calendar": {
                "mode": "month",
                "weeks-pos": "right",
                "format": {
                  "months": "<span color='#c0caf5'><b>{}</b></span>",
                  "days": "<span color='#cdd6f4'>{}</span>",
                  "weeks": "<span color='#7aa2f7'><b>W{}</b></span>",
                  "today": "<span color='#f7768e'><b><u>{}</u></b></span>"
                }
              },
              "format-alt": "󰸗 {:%Y-%m-%d}"
            },
            "network": {
              "format-wifi": "󰖩 {essid} ({signalStrength}%)",
              "format-ethernet": "󰈀 {ipaddr}",
              "format-disconnected": "󰖪 Disconnected",
              "tooltip-format": "{ifname}: {ipaddr}/{cidr}",
              "on-click": "nm-applet"
            },
            "pulseaudio": {
              "format": "{icon} {volume}%",
              "format-muted": "󰖁 Muted",
              "format-icons": {
                "headphone": "",
                "hands-free": "",
                "headset": "",
                "phone": "",
                "portable": "",
                "car": "",
                "default": ["", "", ""]
              },
              "on-click": "pavucontrol"
            },
            "cpu": {
              "format": "󰍛 {usage}%",
              "tooltip": true
            },
            "memory": {
              "format": "󰘚 {used:0.1f}G/{total:0.1f}G",
              "tooltip": true
            },
            "battery": {
              "states": {
                "warning": 30,
                "critical": 15
              },
              "format": "{icon} {capacity}%",
              "format-charging": "󰂄 {capacity}%",
              "format-plugged": "󰂄 {capacity}%",
              "format-full": "󱈑 {capacity}%",
              "format-icons": ["󱊡", "󱊢", "󱊣"]
            },
            "mpris": {
              "format": "{player_icon} {title} - {artist}",
              "format-paused": "{status_icon} <i>{title} - {artist}</i>",
              "player-icons": {
                "default": "󰝚",
                "spotify": "󰓇",
                "firefox": "󰈹"
              },
              "status-icons": {
                "paused": "⏸"
              },
              "max-length": 40,
              "on-click": "playerctl play-pause"
            },
            "custom/date": {
              "format": "󰸗 {}",
              "interval": 3600,
              "exec": "$HOME/bin/waybar-date.sh",
              "return-type": "string"
            },
            "custom/power": {
              "format": "󰐥",
              "on-click": "$HOME/bin/waybar-power.sh",
              "return-type": "string"
            },
            "tray": {
              "icon-size": 16,
              "spacing": 8
            }
          }
        '';
      };
      ".config/waybar/style.css" = {
        text = /*css*/''
          * {
              border: none;
              border-radius: 0;
              font-family: JetBrains Mono, FontAwesome, mononoki Nerd Font, sans-serif;
              font-size: 14px;
              color: #c0caf5;
              min-height: 0;
          }

          window#waybar {
              background: rgba(36, 40, 59, 0.85);
              border-bottom: 2px solid #7aa2f7;
              transition: background-color 0.3s ease, opacity 0.3s ease;
          }

          window#waybar.hidden {
              opacity: 0.3;
          }

          #workspaces, #window, #clock, #network, #pulseaudio, #cpu, #memory, #battery, #mpris, #custom-date, #custom-power, #tray {
              background: #24283b;
              margin: 4px 2px;
              padding: 0 8px;
              border-radius: 8px;
              transition: background-color 0.2s ease;
          }

          #workspaces button {
              padding: 0 8px;
              color: #c0caf5;
              background: transparent;
              border: none;
              transition: all 0.2s ease;
          }

          #workspaces button.active {
              background: #7aa2f7;
              color: #1a1b26;
              border-radius: 6px;
          }

          #workspaces button:hover {
              background: #414868;
              color: #cdd6f4;
          }

          #pulseaudio.muted {
              color: #f7768e;
          }

          #network.disconnected {
              color: #f7768e;
          }

          #battery.critical:not(.charging) {
              color: #f7768e;
              animation: blink 1s infinite;
          }

          #mpris.paused {
              color: #737aa2;
          }

          #custom-power {
              background: #db4b4b;
              color: #1a1b26;
              border-radius: 8px;
              padding: 0 12px;
          }

          #custom-power:hover {
              background: #f7768e;
              transition: background-color 0.2s ease;
          }

          #tray > .passive {
              -gtk-icon-effect: dim;
          }

          #tray > .active {
              -gtk-icon-effect: highlight;
          }

          @keyframes blink {
              to { opacity: 0.6; }
          }

          tooltip {
              background: #1a1b26;
              border: 1px solid #7aa2f7;
              border-radius: 8px;
          }

          tooltip label {
              color: #c0caf5;
              padding: 4px;
          }

          window#waybar {
              animation: fadeIn 0.5s ease-in;
          }

          @keyframes fadeIn {
              from { opacity: 0; }
              to { opacity: 1; }
          }
        '';
      };
      "bin/waybar-date.sh" = {
        text = /*bash*/''
          #!/usr/bin/env bash
          date +"%Y-%m-%d"
        '';
        executable = true;
      };
      "bin/waybar-power.sh" = {
        text = /*bash*/''
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
        '';
        executable = true;
      };
    };
  };
}
