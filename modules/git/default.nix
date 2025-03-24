{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.modules.git;
in
{
  options.modules.git = { enable = mkEnableOption "git"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      git
      lazygit
    ];

    programs.git = {
      enable = true;
      extraConfig = {
        user.name = "rafael-dvpy";
        user.email = "rafa.dev.oliveira@gmail.com";
        init.defaultBranch = "main";
      };
    };
  };
}

