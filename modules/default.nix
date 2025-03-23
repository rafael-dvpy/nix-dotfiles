{ inputs, pkgs, config, ... }:

{
  home.stateVersion = "24.11";
  imports = [
    # gui
    ./hyprland
    ./waybar
    ./dunst
    ./wofi

    # cli
    ./ghostty
    ./foot
    ./nvim
    ./scripts
    ./zsh

    # system
    ./packages
  ];
}
