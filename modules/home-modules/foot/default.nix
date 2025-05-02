{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.foot;

in
{
  options.modules.foot = { enable = mkEnableOption "foot"; };
  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=9";
          pad = "12x12";
        };
        colors = {
          foreground = "c0caf5";
          background = "24283b";
          selection-foreground = "24283b";
          selection-background = "7aa2f7";

          ## Normal colors
          regular0 = "414868"; # black (terminal_black)
          regular1 = "f7768e"; # red
          regular2 = "9ece6a"; # green
          regular3 = "e0af68"; # yellow
          regular4 = "7aa2f7"; # blue
          regular5 = "bb9af7"; # magenta
          regular6 = "7dcfff"; # cyan
          regular7 = "a9b1d6"; # white (fg_dark)

          ## Bright colors
          bright0 = "3b4261"; # bright black (fg_gutter)
          bright1 = "db4b4b"; # bright red
          bright2 = "73daca"; # bright green
          bright3 = "ff9e64"; # bright yellow (orange)
          bright4 = "2ac3de"; # bright blue (blue1)
          bright5 = "ff007c"; # bright magenta (magenta2)
          bright6 = "b4f9f8"; # bright cyan (blue6)
          bright7 = "c0caf5"; # bright white (fg)

          ## Optional dimmed colors (foot supports up to 16)
          dim0 = "ff9e64";
          dim1 = "db4b4b";
        };
      };
    };
  };
}
