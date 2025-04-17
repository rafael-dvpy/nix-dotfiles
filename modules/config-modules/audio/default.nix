{ pkgs, lib, config, ... }:

{
  options =
    {
      audio.enable = lib.mkEnableOption "enable audio";
    };

  config = lib.mkIf config.audio.enable {
    environment.systemPackages = with pkgs; [
      alsa-utils
    ];

    hardware.alsa.enablePersistence = true;

    programs.noisetorch.enable = true;
    # Enables Audio
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
}
