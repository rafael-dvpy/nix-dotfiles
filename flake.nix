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
          ./hosts/tokyo/user.nix
        ];
      };

      nixosConfigurations.nord = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [
          { networking.hostName = "nord"; }

          ./modules/config-modules/default.nix
          ./hosts/nord/hardware-configuration.nix
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
              users.rafael = (./hosts/nord/user.nix);
            };
          })
        ];
      };

      nixosConfigurations.tokyo = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [
          { networking.hostName = "tokyo"; }

          ./modules/config-modules/default.nix
          ./hosts/tokyo/hardware-configuration.nix
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
              users.rafael = (./hosts/tokyo/user.nix);
            };
          })
        ];
      };


      devShells.${system} = {

        default = pkgs.mkShell
          {
            shellHook = ''
              zsh
            '';
            buildInputs = with pkgs; [
              neovim
              rustc
              rust-analyzer
              cargo
              libgcc
              lua5_1
              luarocks
              nodejs
              lua-language-server
            ];
          };


        node = pkgs.mkShell
          {
            shellHook = ''
              zsh
            '';
            buildInputs = with pkgs; [
              neovim
              nodejs
              rustc
              cargo
              libgcc
            ];
          };

      };

    };
}

