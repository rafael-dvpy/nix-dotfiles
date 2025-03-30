{ pkgs, lib, config, ... }:

{
  options =
    {
      fonts.enable = lib.mkEnableOption "enable fonts";
    };

  config = lib.mkIf config.fonts.enable {
    # Install fonts
    fonts = {
      packages = with pkgs;
        [
          jetbrains-mono
          nerd-fonts.jetbrains-mono
          roboto
          openmoji-color
        ];

      fontconfig = {
        hinting.autohint = true;
        defaultFonts = {
          emoji = [ "OpenMoji Color" ];
        };
      };
    };
  };
}
