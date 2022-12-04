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
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # neovim nightly
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    # flake-utils
    # flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, darwin, nixpkgs, home-manager, nur, ... }@inputs:
  let

    # inherit (inputs.nixpkgs.lib) attrValues makeOverridable optionalAttrs singleton;
    # inherit (self.lib) attrValues makeOverridable optionalAttrs singleton;
    inherit (nixpkgs.lib) attrValues;

    homeStateVersion = "22.11";

    # Configuration for `nixpkgs`
    nixpkgsConfig = {
      config = { allowUnfree = true; };
    };

    # XXX not used yet, to be used with flake-utils?
    # from DPD-
    machines = [
      {
        host = "brutal";
        system = "x86_64-linux";
        users = [ "baptiste" ];
      }
      {
        host = "Baptiste-MBP";
        system = "x86_64-darwin";
        users = [ "baptiste" ];
      }
    ];

    # Used for some modules
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
     my-git = import ./home/git.nix;
     my-tmux = import ./home/tmux.nix;
     my-keybase = import ./home/keybase.nix;
     my-firefox = import ./home/firefox.nix;
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
      brutal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # https://github.com/jules-goose/nixcfg/blob/0db16d98d049c1eb7c11f31c5ddbbcd2146e4f15/flake.nix#L22
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ inputs.nur.overlay ];
        };
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
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.baptiste = {
             imports = attrValues self.homeManagerModules;
             # XXX Unused, to be removed?
             home.stateVersion = homeStateVersion;
             home.user-info = primaryUserDefaults;
             };
          }
        ];
      };
    };

    # `nix-darwin` configs
    darwinConfigurations = {
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
