{ config, lib, pkgs, inputs, hostname, ... }:

{
  imports = [
    ../../modules/home/hyprland/default.nix
    ../../modules/home/waybar/default.nix
    ../../modules/home/dunst/default.nix
    ../../modules/home/zen/default.nix
    ../../modules/home/gtk/default.nix
    ../../modules/home/ghostty/default.nix
    ../../modules/home/foot/default.nix
    ../../modules/home/nvim/default.nix
    ../../modules/home/scripts/default.nix
    ../../modules/home/zsh/default.nix
    ../../modules/home/git/default.nix
    ../../modules/home/docker/default.nix
    ../../modules/home/tmux/default.nix
    ../../modules/home/packages/default.nix
    ../../modules/home/wofi/default.nix
    ../../modules/home/eww/default.nix
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
    wofi.enable = true;
    eww.enable = true;
  };
}
