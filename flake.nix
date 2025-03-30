{
  description = "Home Manager configuration of rafael";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."rafael" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home = {
              username = "rafael";
              homeDirectory = "/home/rafael";
            };
          }
          ./hosts/desktop/user.nix
        ];
      };

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [
          { networking.hostName = "desktop"; }

          ./modules/config-modules/default.nix
          ./hosts/desktop/hardware-configuration.nix

          inputs.xremap-flake.nixosModules.default
          {
            services.xremap.yamlConfig = ''
              modmap:
                - name: Global
                  remap:
                    CAPSLOCK:
                      held: CAPSLOCK
                      alone: ESC
                      alone_timeout_millis: 150
                    RIGHTCTRL: EQUAL
              virtual_modifiers:
                - CapsLock
              keymap:
                - name: Schmoving
                  remap:
                    CapsLock-i: Up
                    CapsLock-j: Left
                    CapsLock-k: Down
                    CapsLock-l: Right

            '';
          }

          home-manager.nixosModules.home-manager
          ({ config, ... }: {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = {
                inherit inputs;
                inherit system;
                inherit (config.networking) hostName;
              };
              # Home manager config (configures programs like firefox, zsh, eww, etc)
              users.rafael = (./hosts/desktop/user.nix);
            };
          })
        ];
      };

      devShells.${system}.default =
        pkgs.mkShell
          {
            buildInputs = with pkgs; [
              neovim
              rustc
              cargo
              libgcc
            ];
          };



    };
}

