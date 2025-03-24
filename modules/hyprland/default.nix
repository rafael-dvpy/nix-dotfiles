{ inputs, pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.hyprland;

in
{
  options.modules.hyprland = { enable = mkEnableOption "hyprland"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wofi
      swaybg
      wlsunset
      wl-clipboard
      hyprland
      grim
    ];

    # Optional, hint Electron apps to use Wayland:
    home.sessionVariables.NIXOS_OZONE_WL = "1";

    home.file = {
      ".config/hypr/hyprland.conf" = {
        source = ./hyprland.conf;
      };
    };
  };
}
