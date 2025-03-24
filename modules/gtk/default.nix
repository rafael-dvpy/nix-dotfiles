{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.modules.gtk;
in
{
  options.modules.gtk = { enable = mkEnableOption "gtk"; };
  config = mkIf cfg.enable {

    home.pointerCursor = {
      package = pkgs.graphite-cursors;
      name = "graphite-dark";
      size = 17;
    };

    home.sessionVariables = {
      XCURSOR_PATH = "${pkgs.graphite-cursors}/share/icons";
      XCURSOR_SIZE = 17;
      XCURSOR_THEME = "graphite-dark";
    };

    gtk = {
      enable = true;
      theme = {
        name = "Tokyonight-Dark";
        package = pkgs.tokyonight-gtk-theme;
      };

      iconTheme = {
        package = pkgs.zafiro-icons;
        name = "Zafiro-icons-Dark";
      };

      cursorTheme = {
        package = pkgs.graphite-cursors;
        name = "graphite-dark";
        size = 17;
      };
    };


  };
}


