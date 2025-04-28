{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.nvim;
in
{
  options.modules.nvim = { enable = mkEnableOption "nvim"; };
  config = mkIf cfg.enable {

    home.file = {
      ".config/nvim/" = {
        source = config.lib.file.mkOutOfStoreSymlink ./nvim-config;
      };
    };

    home.sessionVariables = {
      EDITOR = "nvim";
    };

  };
}
