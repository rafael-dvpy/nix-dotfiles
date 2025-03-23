{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.ghostty;

in
{
  options.modules.ghostty = { enable = mkEnableOption "ghostty"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ghostty
    ];
    home.file = {
      ".config/ghostty/config" = {
        source = ./config;
      };
    };
  };
}
