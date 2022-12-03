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

    # Colors for various apps
    # XXX errors when trying to use
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }@inputs:
  let

    # inherit (inputs.nixpkgs.lib) attrValues makeOverridable optionalAttrs singleton;
    # inherit (self.lib) attrValues makeOverridable optionalAttrs singleton;
    inherit (nixpkgs.lib) attrValues;

    homeStateVersion = "22.11";

    # Configuration for `nixpkgs`
    nixpkgsConfig = {
      config = { allowUnfree = true; };
    };

    primaryUserDefaults = {
       username = "baptiste";
       fullName = "Baptiste Grenier";
       email = "baptiste@bapt.name";
       nixConfigDirectory = "/home/baptiste/repos/dotfiles/";
     };
  in
  {
   systemModules = {
     my-bootstrap = import ./modules/system/bootstrap.nix;
     users-primaryUser = import ./modules/system/users.nix;
   };
   homeManagerModules = {
     # https://github.com/malob/nixpkgs
     my-colors = import ./home/colors.nix;
     my-kitty = import ./home/kitty.nix;
     my-fish = import ./home/fish.nix;
     my-starship = import ./home/starship.nix;
     my-starship-symbols = import ./home/starship-symbols.nix;
     my-neovim = import ./home/neovim.nix;
     my-main = import ./home/main.nix;

     # Custom modules from gh:malob
     colors = import ./modules/home/colors;
     # https://github.com/RichardYan314/dotfiles-nix/tree/c18de97ad9e7ae1ff46c806be2f0f91c43d5956e/users/colorschemes
     programs-neovim-extras = import ./modules/home/programs/neovim/extras.nix;
     programs-kitty-extras = import ./modules/home/programs/kitty/extras.nix;
     home-user-info = { lib, ... }: {
          options.home.user-info = (self.systemModules.users-primaryUser { inherit lib; }).options.users.primaryUser;
        };
   };

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
            home-manager.users.baptiste = {
             imports = attrValues self.homeManagerModules;
             home.stateVersion = homeStateVersion;
             home.user-info = primaryUserDefaults;
             # theme = {
             #  name = "Dracula";
             #    package = self.pkgs.dracula-theme;
             #  };
             };
           # extraSpecialArgs = { inherit nix-colors; };
          }
        ];
	      specialArgs = { inherit inputs; };
      };
    };

    # `nix-darwin` configs
    darwinConfigurations = rec {
      Baptistes-MBP = darwin.lib.darwinSystem {
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
