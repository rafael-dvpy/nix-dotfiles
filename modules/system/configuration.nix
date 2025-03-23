# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  environment.defaultPackages = [ ];
  services.xserver.desktopManager.xterm.enable = false;

  programs.zsh.enable = true;
  programs.waybar.enable = true;

  # Laptop-specific packages (the other ones are installed in `packages.nix`)
  environment.systemPackages = with pkgs; [
    acpi
    tlp
    git
  ];

  environment.variables = {
    XDG_DOCUMENT_DIR = "$HOME/stuff/other/";
    XDG_DOWNLOAD_DIR = "$HOME/stuff/other/";
    XDG_VIDEOS_DIR = "$HOME/stuff/other/";
    XDG_MUSIC_DIR = "$HOME/stuff/music/";
    XDG_PICTURES_DIR = "$HOME/stuff/pictures/";
    XDG_DESKTOP_DIR = "$HOME/stuff/other/";
    XDG_PUBLICSHARE_DIR = "$HOME/stuff/other/";
    XDG_TEMPLATES_DIR = "$HOME/stuff/other/";
  };

  # Install fonts
  fonts = {
    packages = with pkgs; [
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


  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  programs.hyprland.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enables Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rafael = {
    isNormalUser = true;
    description = "Rafael Oliveira";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #  thunderbir
      neovim
      home-manager
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11"; # Did you read the comment?

}
