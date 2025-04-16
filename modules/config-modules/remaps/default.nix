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
              grv      1        2        3        4        5        6        7        8        9        0        -        =        bspc
              tab      q        w        e        r        t        y        u        i        o        p        [        ]        \
              caps     a        s        d        f        g        h        j        k        l        ;        '        ret
              lsft     z        x        c        v        b        n        m        ,        .        /        rsft
              lctl     lmet     lalt                       spc                        ralt     rmet     rctl
            )

            (defvar
              tap-time        200
              chord-time      15
              hold-time       200
              hold-time-slow  300
            )

            (defalias
              del   del
              spc   (tap-hold 200 200 spc (layer-toggle sym_1))

              a     (multi f24 (tap-hold $tap-time $hold-time-slow a lmet))
              s     (multi f24 (tap-hold $tap-time $hold-time-slow s lalt))
              d     (multi f24 (tap-hold $tap-time $hold-time      d lsft))
              f     (multi f24 (tap-hold $tap-time $hold-time      f lctl))
              j     (multi f24 (tap-hold $tap-time $hold-time      j lctl))
              k     (multi f24 (tap-hold $tap-time $hold-time      k lsft))
              l     (multi f24 (tap-hold $tap-time $hold-time-slow l lalt))
              ;     (multi f24 (tap-hold $tap-time $hold-time-slow ; lmet))
              c     (multi f24 (tap-hold $tap-time $hold-time      c (layer-toggle cmd)))
              m     (multi f24 (tap-hold $tap-time $hold-time      m (layer-toggle cmd)))
              caps  (multi f24 (tap-hold $tap-time $hold-time-slow esc lctl))
              c_j (chord escape j)
              c_k (chord escape k)
              c_f (chord delete f)
              c_d (chord delete d)
              c_s (chord delete s)
            )
            (defchords escape $chord-time
              (j  ) @j
              (  k) @k
              (j k) esc 
            )
            (defchords delete $chord-time
              (f    ) @f
              (  d  ) @d
              (    s) @s
              (f d  ) C-bspc 
              (f   s) C-del 
            )

            (deflayer base
              grv      1        2        3        4        5        6        7        8        9        0        -        =        bspc
              tab      q        w        e        r        t        y        u        i        o        p        [        ]        \
              @caps    @a       @c_s     @c_d     @c_f     g        h        @c_j     @c_k     @l       @;       '        ret
              lsft     z        x        @c       v        b        n        @m        ,        .        /        rsft
              lctl     lmet     lalt                       @spc                       ralt     rmet     rctl
            )

            (deflayer cmd
              grv      1        2        3        4        5        6        7        8        9        0        -        =        bspc
              tab      C-w      C-tab    C-S-tab  r        C-t      y        bspc     up       @del     ret      [        ]        \
              caps     a        C-del    C-bspc   f        g        h        left     down     right    ;        '        ret
              lsft     z        x        c        v        b        lsft     m        ,        .        /        rsft
              lctl     lmet     lalt                       spc                        ralt     rmet     rctl
            )

            (deflayer sym_1
              grv      1        2        3        4        5        6        7        8        9        0        -        =        bspc
              tab      S-1      S-2      S-3      S-4      S-5      S-6      S-7      S-8      S-9      S-0      [        ]        \
              caps     `        -        /        S-/      '        h        ;        S-;      [        ]        '        ret
              lsft     S-`      S--      \        S-\      S-'      lsft     +        =        S-[      S-]      rsft
              lctl     lmet     lalt                       spc                        ralt     rmet     rctl
            )
          '';
        };
      };
    };
  };
}

