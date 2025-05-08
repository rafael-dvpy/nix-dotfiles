{ inputs, pkgs, config, ... }:

{
  home.stateVersion = "24.11";
  imports = [
    # gui
    ./hyprland
    ./waybar
    ./dunst
    ./zen
    ./gtk

    # cli
    ./ghostty
    ./foot
    ./nvim
    ./scripts
    ./zsh
    ./git
    ./docker
    ./tmux

    # system
    ./packages
  ];
}
