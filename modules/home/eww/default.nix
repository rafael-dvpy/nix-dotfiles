{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.eww;
  configDir = ./config;
in
{
  options.modules.eww = { enable = mkEnableOption "EWW widget system"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      eww
      polkit_gnome # For power menu permissions
    ];

    home.file = {
      ".config/eww/eww.yuck".source = "${configDir}/eww.yuck";
      ".config/eww/eww.scss".source = "${configDir}/eww.scss";
      ".config/eww/scripts/eww-power.sh" = {
        source = "${configDir}/scripts/eww-power.sh";
        executable = true;
      };
    };
  };
}
