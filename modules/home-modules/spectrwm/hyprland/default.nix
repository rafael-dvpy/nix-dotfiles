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

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 300;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 5;
            placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
            shadow_passes = 2;
          }
        ];
      };
    };

    # Optional, hint Electron apps to use Wayland:
    home.sessionVariables.NIXOS_OZONE_WL = "1";

    home.file = {
      ".config/hypr/hyprland.conf" = {
        source = ./hyprland.conf;
      };
    };
  };
}
