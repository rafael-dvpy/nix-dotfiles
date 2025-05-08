{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.wofi;
  configDir = ./config;
in {
  options.modules.wofi = { enable = mkEnableOption "Wofi application launcher"; };

  config = mkIf cfg.enable {
    # Enable Wofi via Home Manager
    programs.wofi = {
      enable = true;
      settings = {
        mode = "drun";
        insensitive = true;
        show = "drun";
        width = 600;
        height = 400;
        always_parse_args = true;
        show_all = false;
        term = "foot";
      };
    };

    # Manage Wofi CSS configuration
    home.file.".config/wofi.css".source = "${configDir}/wofi.css";
  };
}
