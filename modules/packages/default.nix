{ pkgs, lib, config, ... }:

with lib;
let
  cfg =
    config.modules.packages;
in
{
  options.modules.packages = { enable = mkEnableOption "packages"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep
      ffmpeg
      tealdeer
      htop
      fzf
      zig
      pass
      gnupg
      bat
      unzip
      lowdown
      zk
      grim
      slurp
      slop
      imagemagick
      age
      libnotify
      git
      python3
      lua
      mpv
      firefox
      eza
      pqiv
      wf-recorder
      anki-bin
      cargo
      rustc
      libgcc
    ];
  };
}
