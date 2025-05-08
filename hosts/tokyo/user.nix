{ config, lib, pkgs, inputs, hostname, ... }:

{
  # Import individual Home Manager modules for granularity
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
