{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.waybar;
  configDir = ./waybar-config;
in {
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
      curl # For weather script
    ];

    home.file = {
      "bin/waybar-date.sh" = {
        source = "${configDir}/scripts/waybar-date.sh";
        executable = true;
      };
      "bin/waybar-power.sh" = {
        source = "${configDir}/scripts/waybar-power.sh";
        executable = true;
      };
      "bin/waybar-weather.sh" = {
        source = "${configDir}/scripts/waybar-weather.sh";
        executable = true;
      };
    };
  };
}
