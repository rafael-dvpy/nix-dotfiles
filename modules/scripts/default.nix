{ hostName, pkgs, lib, config, ... }:

with lib;
let
  cfg = config.modules.scripts;
in
{
  options.modules.scripts = { enable = mkEnableOption "scripts"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs;[
      (writeShellScriptBin "bandw" (builtins.readFile ./bandw))
      (writeShellScriptBin "screen" (builtins.readFile ./screen))
      (writeShellScriptBin "maintenance" /*bash*/''
        sudo nix-collect-garbage -d
        sudo nix store verify --all
        sudo nix store repair --all
        cd $NIXOS_CONFIG_DIR 
        nix flake update
        sudo nixos-rebuild switch --flake $HOME/.config/home-manager#${hostName} --upgrade
        nix run nixpkgs#bleachbit
      '')
    ];
  };
}
