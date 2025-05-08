{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.waybar;
  configDir = ./waybar-config;
in
{
  options.modules.waybar = { enable = mkEnableOption "Waybar status bar"; };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = [
        (builtins.fromJSON (builtins.readFile "${configDir}/config"))
      ];
      style = builtins.readFile "${configDir}/style.css";
    };

    home.packages = with pkgs; [
      font-awesome # For icons
      playerctl # For Waybar modules
      polkit_gnome # For systemctl permissions
    ];
  };
}
