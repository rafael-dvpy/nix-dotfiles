{ hostName, pkgs, lib, config, ... }:

with lib;
let
  cfg = config.modules.scripts;
in
{
  options.modules.scripts = { enable = mkEnableOption "scripts"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs;[
      (writeShellScriptBin "bandw" (builtins.readFile ./bandw))

      (writeShellScriptBin "screen" (builtins.readFile ./screen))

      (writeShellScriptBin "tmux-sessionizer" /*bash*/''
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

      (writeShellScriptBin "maintenance" /*bash*/''
        sudo nix-collect-garbage -d
        sudo nix store verify --all
        sudo nix store repair --all
        cd $HOME/.config/home-manager 
        nix flake update
        sudo nixos-rebuild switch --flake $HOME/.config/home-manager#${hostName} --upgrade
        nix run nixpkgs#bleachbit
      '')
    ];
  };
}
