{ config, lib, pkgs, inputs, hostname, ... }:
   {
     imports = [
       ../../modules/home/hyprland.nix
       ../../modules/home/waybar.nix
       ../../modules/home/dunst.nix
       ../../modules/home/zen.nix
       ../../modules/home/gtk.nix
       ../../modules/home/ghostty.nix
       ../../modules/home/foot.nix
       ../../modules/home/nvim.nix
       ../../modules/home/scripts.nix
       ../../modules/home/zsh.nix
       ../../modules/home/git.nix
       ../../modules/home/docker.nix
       ../../modules/home/tmux.nix
       ../../modules/home/packages.nix
     ];
     home = {
       username = "rafael";
       homeDirectory = "/home/rafael";
       stateVersion = "23.11";
     };
     modules = {
       hyprland.enable = true;
       waybar.enable = true;
       dunst.enable = true;
       zen.enable = true;
       gtk.enable = true;
       ghostty.enable = true;
       foot.enable = true;
       nvim.enable = true;
       scripts.enable = true;
       zsh.enable = true;
       git.enable = true;
       docker.enable = true;
       tmux.enable = true;
       packages.enable = true;
     };
     # Host-specific customizations for 'nord'
     # programs.zsh.initExtra = lib.mkIf (hostname == "nord") ''
     #   export PROMPT="nord> "
     # '';
   }
