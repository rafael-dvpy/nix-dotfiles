{
  description = "Rafael's NixOS and Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, ... }@inputs:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});

      commonHomeManager = { system, hostname, userConfig }: {
        useUserPackages = true;
        useGlobalPkgs = true;
        extraSpecialArgs = { 
          inherit inputs system hostname;
          hostName = hostname; # Backward compatibility
        };
        users.rafael = userConfig;
      };

      mkNixosConfig = { system, hostname, hardwareConfig, userConfig }: 
        nixpkgs.lib.nixosSystem {
          specialArgs = { 
            inherit inputs system hostname;
            hostName = hostname; # Backward compatibility
          };
          modules = [
            { networking.hostName = hostname; }
            ./modules/config-modules/default.nix
            hardwareConfig
            home-manager.nixosModules.home-manager
            { home-manager = commonHomeManager { inherit system hostname userConfig; }; }
          ];
        };

      mkHomeConfig = { system, username, homeDir, userConfig }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.${system};
          modules = [
            {
              home = {
                inherit username homeDir;
              };
            }
            userConfig
          ];
        };

      commonDevShell = pkgs: {
        default = pkgs.mkShell {
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
        node = pkgs.mkShell {
          buildInputs = with pkgs; [
            neovim
            nodejs
            rustc
            cargo
            libgcc
          ];
        };
      };

    in {
      homeConfigurations.rafael = mkHomeConfig {
        system = "x86_64-linux";
        username = "rafael";
        homeDir = "/home/rafael";
        userConfig = ./hosts/tokyo/user.nix;
      };

      nixosConfigurations = {
        nord = mkNixosConfig {
          system = "x86_64-linux";
          hostname = "nord";
          hardwareConfig = ./hosts/nord/hardware-configuration.nix;
          userConfig = ./hosts/nord/user.nix;
        };
        tokyo = mkNixosConfig {
          system = "x86_64-linux";
          hostname = "tokyo";
          hardwareConfig = ./hosts/tokyo/hardware-configuration.nix;
          userConfig = ./hosts/tokyo/user.nix;
        };
      };

      devShells = forAllSystems (system: commonDevShell pkgsFor.${system});
    };
}
