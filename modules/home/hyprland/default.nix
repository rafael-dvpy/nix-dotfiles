{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.hyprland;
  configDir = ./config;
in
{
  options.modules.hyprland = { enable = mkEnableOption "Hyprland window manager"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wlsunset
      wl-clipboard
      grim
      slurp
      kdePackages.dolphin
      brightnessctl
      noisetorch
      swaybg
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

    home.sessionVariables.NIXOS_OZONE_WL = "1";

    home.file = {
      ".config/hypr/hyprland.conf".source = "${configDir}/hyprland.conf";
      ".config/hypr/tokyonight-wallpaper.png".source = "${configDir}/tokyonight-wallpaper.png";
      "stuff/captures/.keep".text = "";
      "stuff/notes/.keep".text = "";
    };
  };
}
