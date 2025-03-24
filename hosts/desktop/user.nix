{ config, lib, inputs, ... }:

{
  imports = [
    ../../modules/default.nix
  ];

  config.modules = {
    # gui
    hyprland.enable = true;
    waybar.enable = true;
    dunst.enable = true;
    wofi.enable = true;

    # cli
    ghostty.enable = true;
    foot.enable = false;
    nvim.enable = true;
    scripts.enable = true;
    zsh.enable = true;

    # system
    packages.enable = true;
  };
}
