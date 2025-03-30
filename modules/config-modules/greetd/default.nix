{ pkgs, lib, config, ... }:

{
  options =
    {
      greetd.enable = lib.mkEnableOption "enable greetd";
    };

  config = lib.mkIf config.greetd.enable {
    services.greetd = {
      enable = true;
      package = pkgs.greetd.tuigreet;
      settings = {
        default_session = {
          command = "${lib.makeBinPath [ pkgs.greetd.tuigreet ]}/tuigreet --time --cmd hyprland";
        };
      };
    };
  };
}
