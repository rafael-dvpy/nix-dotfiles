{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.waybar;
in
{
  options.modules.waybar = { enable = mkEnableOption "waybar"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs;[
      waybar
    ];

    home.file = {
      ".config/waybar" = {
        source = config.lib.file.mkOutOfStoreSymlink ./waybar-config;
      };
    };
  };
}
