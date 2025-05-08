{ config, lib, pkgs, inputs, hostname, ... }:

{
  # Import Home Manager modules from subdirectories
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
    ../../modules/home/wofi/default.nix
    ../../modules/home/packages/default.nix
  ];

  # Home Manager user configuration
  home = {
    username = "rafael";
    homeDirectory = "/home/rafael";
    stateVersion = "23.11"; # Adjust based on your Home Manager version
  };

  # Enable and configure modules
  modules = {
    # GUI applications
    hyprland.enable = true;
    waybar.enable = true;
    dunst.enable = true;
    zen.enable = true;
    gtk.enable = true;
    wofi.enable = true;

    # CLI tools
    ghostty.enable = true;
    foot.enable = true;
    nvim.enable = true;
    scripts.enable = true;
    zsh.enable = true;
    git.enable = true;
    docker.enable = true;
    tmux.enable = true;

    # System packages
    packages.enable = true;
  };

  # Host-specific customizations (optional)
  # Example: Adjust settings for 'tokyo'
  # programs.zsh.initExtra = lib.mkIf (hostname == "tokyo") ''
  #   export PROMPT="tokyo> "
  # '';
}
