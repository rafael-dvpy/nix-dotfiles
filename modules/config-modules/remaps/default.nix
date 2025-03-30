{ inputs, pkgs, lib, config, ... }:

{
  options =
    {
      remaps.enable = lib.mkEnableOption "enable remaps";
    };

  config = lib.mkIf config.remaps.enable {
    # Enable the uinput module
    boot.kernelModules = [ "uinput" ];

    # Enable uinput
    hardware.uinput.enable = true;

    # Set up udev rules for uinput
    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';

    # Ensure the uinput group exists
    users.groups.uinput = { };

    # Add the Kanata service user to necessary groups
    systemd.services.kanata-internalKeyboard.serviceConfig = {
      SupplementaryGroups = [
        "input"
        "uinput"
      ];
    };

    services.kanata = {
      enable = true;
      keyboards = {
        internalKeyboard = {
          devices = [
            # Replace the paths below with the appropriate device paths for your setup.
            # Use `ls /dev/input/by-path/` to find your keyboard devices.
            "/dev/input/by-path/pci-0000:01:00.0-usb-0:1:1.1-event-kbd"
            "/dev/input/by-path/pci-0000:01:00.0-usb-0:5:1.0-event-kbd"
            "/dev/input/by-path/pci-0000:01:00.0-usbv2-0:1:1.1-event-kbd"
            "/dev/input/by-path/pci-0000:01:00.0-usbv2-0:5:1.0-event-kbd"
          ];
          extraDefCfg = "process-unmapped-keys yes";
          config = ''
            (defsrc
              caps a s d f h j k l ; i rctrl
            )

            (defvar
              tap-time 200
              hold-time 200
              hold-time-slow 300
            )

            (defalias
              del del
              esc_l-arrow (tap-hold 100 100 esc (layer-toggle arrow))
              a (multi f24 (tap-hold $tap-time $hold-time-slow a lmet))
              s (multi f24 (tap-hold $tap-time $hold-time-slow s lalt))
              d (multi f24 (tap-hold $tap-time $hold-time      d lsft))
              f (multi f24 (tap-hold $tap-time $hold-time      f lctl))
              j (multi f24 (tap-hold $tap-time $hold-time      j lctl))
              k (multi f24 (tap-hold $tap-time $hold-time      k lsft))
              l (multi f24 (tap-hold $tap-time $hold-time-slow l lalt))
              ; (multi f24 (tap-hold $tap-time $hold-time-slow ; lmet))
            )

            (deflayer base
              @esc_l-arrow @a @s @d @f _ @j @k @l @; _ =
            )

            (deflayer arrow
               _ _ _ @del _ _ left down right _ up =
            )
          '';
        };
      };
    };
  };
}

