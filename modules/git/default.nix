{ lib, config, ... }:
with lib;
let
  cfg = config.modules.git;
in
{
  options.modules.git = { enable = mkEnableOption "git"; };
  config = mkIf cfg.enable {

    programs.lazygit.enable = true;

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

