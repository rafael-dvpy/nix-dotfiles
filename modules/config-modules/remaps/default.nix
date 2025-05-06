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
            "/dev/input/by-path/pci-0000:00:14.0-usb-0:2:1.0-event-kbd"
            "/dev/input/by-path/pci-0000:00:14.0-usb-0:2:1.1-event-kbd"
            "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:2:1.0-event-kbd"
            "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:2:1.1-event-kbd"
            "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
            "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
            "/dev/input/by-path/pci-0000:01:00.0-usb-0:1:1.1-event-kbd"
            "/dev/input/by-path/pci-0000:01:00.0-usb-0:5:1.0-event-kbd"
            "/dev/input/by-path/pci-0000:01:00.0-usbv2-0:1:1.1-event-kbd"
            "/dev/input/by-path/pci-0000:01:00.0-usbv2-0:5:1.0-event-kbd"
            "/dev/input/by-path/pci-0000:0b:00.3-usb-0:3:1.1-event-kbd"
            "/dev/input/by-path/pci-0000:0b:00.3-usbv2-0:3:1.1-event-kbd"
            "/dev/input/by-path/pci-0000:01:00.0-usb-0:1:1.0-event-kbd"
            "/dev/input/by-path/pci-0000:01:00.0-usb-0:1:1.1-event-kbd"
            "/dev/input/by-path/pci-0000:01:00.0-usbv2-0:1:1.0-event-kbd"
            "/dev/input/by-path/pci-0000:01:00.0-usbv2-0:1:1.1-event-kbd"
          ];
          extraDefCfg = ''
            process-unmapped-keys no
            concurrent-tap-hold yes
          '';
          config = ''
            (defsrc
              q w e r t y u i o p
              a s d f g h j k l ;
              z x c v b n m , . /
                     spc
            )

            (deftemplate charmod (char mod)
              (switch 
                ((key-timing 3 less-than 375)) $char break
                () (tap-hold-release-timeout 200 500 $char $mod $char) break
              )
            )

            (defvirtualkeys
              shift (multi (layer-switch main) lsft)
              clear (multi (layer-switch main) (on-press release-virtualkey shift))
            )

            (defchords mtl 50
              (w  ) w
              (  e) e
              (w e) esc
            )

            (defchords mtr 50
              (i  ) i
              (  o) o
              (i o) bspc
            )

            (defchords mbl 50
              (x  ) (t! charmod x ralt)
              (  c) c
              (x c) tab
            )

            (defchords mbr 50
              (,  ) ,
              (  .) (t! charmod . ralt)
              (, .) ret
            )

            (deflayermap (main)
              w (chord mtl w)
              e (chord mtl e)
              i (chord mtr i)
              o (chord mtr o)
              a (t! charmod a lmet)
              s (t! charmod s lalt)
              d (t! charmod d lsft)
              f (t! charmod f lctl)
              j (t! charmod j rctl)
              k (t! charmod k rsft)
              l (t! charmod l lalt)
              ; (t! charmod ; rmet)
              z (t! charmod z lctl) 
              x (chord mbl x)
              c (chord mbl c)
              v (t! charmod v (layer-while-held fumbol))
              m (t! charmod m (layer-while-held fumbol))
              , (chord mbr ,)
              . (chord mbr .)
              / (t! charmod / rctl)
              spc (t! charmod spc (multi (layer-switch extend) (on-release tap-virtualkey clear)))
            )

            (deflayermap (mouse)
              w (movemouse-speed 25)
              e (movemouse-speed 50)
              r (movemouse-speed 200)
              s mrgt
              d mmid
              f mlft
              p (mwheel-up 50 120)
              ; (mwheel-down 50 120)
              u (mwheel-left 50 120)
              o (mwheel-right 50 120)
              i (movemouse-up 4 4)
              j (movemouse-left 4 4)
              k (movemouse-down 4 4)
              l (movemouse-right 4 4)
            )

            (deflayermap (extend)
              w (layer-switch mouse)
              e (layer-switch fumbol)
              r (on-press press-virtualkey shift)
              y ins
              u home
              i up
              o end
              p pgup
              a A-1
              s A-2
              d A-3
              f A-4
              g A-5
              h esc
              j left
              k down
              l rght
              ; pgdn
              z A-S-1
              x A-S-2
              c A-S-3
              v A-S-4
              b A-S-5
              n tab
              m bspc
              , spc
              . del
              / ret
            )

            (defchords ftl 50
              (w  ) f2
              (  e) f3
              (w e) esc
            )

            (defchords ftr 50
              (i  ) f8
              (  o) f9
              (i o) bspc
            )

            (defchords fbl 50
              (x  ) (t! charmod ` ralt)
              (  c) -
              (x c) tab
            )

            (defchords fbr 50
              (,  ) [
              (  .) (t! charmod ] ralt)
              (, .) ret
            )

            (deflayermap (fumbol)
              q f1
              w (chord ftl w)
              e (chord ftl e)
              r f4
              t f5
              y f6
              u f7
              i (chord ftr i)
              o (chord ftr o)
              p f10
              [ f11
              ] f12
              \ f13
              a (t! charmod 1 lmet)
              s (t! charmod 2 lalt)
              d (t! charmod 3 lsft)
              f (t! charmod 4 lctl)
              g 5
              h 6
              j (t! charmod 7 rctl)
              k (t! charmod 8 rsft)
              l (t! charmod 9 lalt)
              ; (t! charmod 0 rmet)
              z (t! charmod lsgt lctl)
              x (chord fbl x)
              c (chord fbl c)
              v =
              b f11
              n f12
              m '
              , (chord fbr ,)
              . (chord fbr .)
              / (t! charmod \ lctl)
            )
          '';
        };
      };
    };
  };
}

