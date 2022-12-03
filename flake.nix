{
  # Inspirations
  # - https://discourse.nixos.org/t/system-config-flake-with-darwin-and-linux-system-definitions/22343
  description = "Baptiste's systems";

  inputs = {
    # Package sets
    # XXX This is only for darwin, what about nixos systems?
    # nixpkgs.url = (if pkgs.stdenv.isDarwn then "github:nixos/nixpkgs/nixpkgs-22.11-darwin" else "github:nixos/nixpkgs/nixos-22.11");
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.11-darwin";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # macOS system configuration
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # home-manager
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # flake-utils
    # flake-utils.url = "github:numtide/flake-utils";
  };

  # outputs = { self, darwin, nixpkgs, home-manager, flake-utils, ... }@inputs:
  outputs = { self, darwin, nixpkgs, home-manager, ... }@inputs:
  let

    inherit (darwin.lib) darwinSystem;
    # inherit (inputs.nixpkgs.lib) attrValues makeOverridable optionalAttrs singleton;

    # Configuration for `nixpkgs`
    nixpkgsConfig = {
      config = { allowUnfree = true; };
    };
  in
  {
    # `home-manager` configs, for systems not running Nix OS
    # homemManagerConfigurations = {
    #    import ./home-conf.nix {
    #      inherit (inputs) nixpkgs home-manager;
    #      nixosConfigs = inputs.self.nixosConfigurations;
    #    }
    # }

    # `nixos` configs
    nixosConfigurations = {
      brutal = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Main config
          ./configuration-brutal.nix

          # `home-manager` module
          home-manager.nixosModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            # install packages to /etc/profiles
            home-manager.useUserPackages = true;
            home-manager.users.baptiste = import ./home.nix;
          }
        ];
	specialArgs = { inherit inputs; };
      };
    };

    # `nix-darwin` configs
    darwinConfigurations = rec {
      Baptistes-MBP = darwinSystem {
        system = "x86_64-darwin";
        modules = [
          # Main `nix-darwin` config
          ./configuration.nix

          # `home-manager` module
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.baptiste = import ./home.nix;
          }
        ];
      };
    };
 };
}
