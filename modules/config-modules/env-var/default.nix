{ pkgs, lib, config, ... }:

{
  options =
    {
      env-var.enable = lib.mkEnableOption "enable env-var";
    };

  config = lib.mkIf config.env-var.enable {

    environment.variables = {
      FLAKE = "$HOME/.config/home-manager/";
      XDG_DOCUMENT_DIR = "$HOME/stuff/other/";
      XDG_DOWNLOAD_DIR = "$HOME/stuff/other/";
      XDG_VIDEOS_DIR = "$HOME/stuff/other/";
      XDG_MUSIC_DIR = "$HOME/stuff/music/";
      XDG_PICTURES_DIR = "$HOME/stuff/pictures/";
      XDG_DESKTOP_DIR = "$HOME/stuff/other/";
      XDG_PUBLICSHARE_DIR = "$HOME/stuff/other/";
      XDG_TEMPLATES_DIR = "$HOME/stuff/other/";
    };

  };
}

