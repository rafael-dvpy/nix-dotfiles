{ hostName, pkgs, lib, config, ... }:
with lib;
let
  cfg = config.modules.scripts;
in
{
  options.modules.scripts = { enable = mkEnableOption "scripts"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      iftop
      brightnessctl
      (writeShellScriptBin "bandw" ''
        #!/usr/bin/env bash
        set -e
        if ! command -v iftop >/dev/null 2>&1; then
          echo "iftop not found. Please install it."
          exit 1
        fi
        sudo iftop -i $(ip link | grep 'state UP' | awk -F': ' '{print $2}' | head -n 1)
      '')
      (writeShellScriptBin "screen" ''
        #!/usr/bin/env bash
        set -e
        if ! command -v brightnessctl >/dev/null 2>&1; then
          echo "brightnessctl not found. Please install it."
          exit 1
        fi
        current=$(brightnessctl | grep 'Current brightness' | awk '{print $4}' | tr -d '()%')
        max=$(brightnessctl | grep 'Max brightness' | awk '{print $3}')
        case "$1" in
          up)
            brightnessctl set +10%
            ;;
          down)
            brightnessctl set 10%-
            ;;
          *)
            echo "Usage: $0 {up|down}"
            exit 1
            ;;
        esac
        new=$(brightnessctl | grep 'Current brightness' | awk '{print $4}' | tr -d '()%')
        percent=$((new * 100 / max))
        notify-send -t 1000 "Brightness" "$percent%"
      '')
      (writeShellScriptBin "tmux-sessionizer" ''
        #!/usr/bin/env bash
        if [[ $# -eq 1 ]]; then
            selected=$1
        else
            selected=$(find ~/projects ~/tests -mindepth 1 -maxdepth 1 -type d | fzf)
        fi
        if [[ -z $selected ]]; then
            exit 0
        fi
        selected_name=$(basename "$selected" | tr . _)
        tmux_running=$(pgrep tmux)
        if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
            tmux new-session -s $selected_name -c $selected
            exit 0
        fi
        if ! tmux has-session -t=$selected_name 2> /dev/null; then
            tmux new-session -ds $selected_name -c $selected
        fi
        if [[ -z $TMUX ]]; then
            tmux attach -t $selected_name
        else
            tmux switch-client -t $selected_name
        fi
      '')
      (writeShellScriptBin "maintenance" ''
        #!/usr/bin/env bash
        set -e
        sudo nix-collect-garbage -d || { echo "Garbage collection failed"; exit 1; }
        sudo nix store verify --all || { echo "Store verification failed"; exit 1; }
        sudo nix store repair --all || { echo "Store repair failed"; exit 1; }
        cd $HOME/.config/home-manager
        nix flake update || { echo "Flake update failed"; exit 1; }
        sudo nixos-rebuild switch --flake $HOME/.config/home-manager#${hostName} --upgrade || { echo "Rebuild failed"; exit 1; }
        nix run nixpkgs#bleachbit || { echo "Bleachbit failed"; exit 1; }
        notify-send "Maintenance" "System maintenance complete!"
      '')
    ];
  };
}
