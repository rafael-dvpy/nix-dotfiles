{ lib, config, inputs, system, ... }:
with lib;
let
  cfg = config.modules.zen;
in
{
  options.modules.zen = { enable = mkEnableOption "zen"; };
  config = mkIf cfg.enable {
    home.packages = [
      inputs.zen-browser.packages."${system}".default
    ];
  };
}

