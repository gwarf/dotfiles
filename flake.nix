{
  # Inspirations
  description = "Baptiste's systems";

  inputs = {
    # Package sets
    # XXX clarify differences between release-22.11 and nixos-22.11, if any
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";
    # XXX Should we use nixos-22.11 as nixpkigs on NixOS?
    nixos-stable.url = "github:nixos/nixpkgs/nixos-22.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # XXX should we use darwin as nixpkgs on darwin?
    nixpkgs-darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-22.11-darwin";

    # macOS system configuration
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin-stable";
    };

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
      # XXX should we use nixpkgs-stable-darwin on darwin?
      # inputs.nixpkgs.follows = "nixpkgs-stable-darwin";
    };

    # neovim nightly
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix2lua.url = "git+https://git.pleshevski.ru/mynix/nix2lua";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, darwin, nixpkgs, nixpkgs-darwin-stable, home-manager, ... }@inputs:
  let

    inherit (nixpkgs.lib) attrValues;

    homeStateVersion = "22.11";

    # Configuration for `nixpkgs`
    nixpkgsConfig = {
      config = { allowUnfree = true; };
    };

    # Information about the main user
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
   # XXX Factorise and simplify like done in https://github.com/gvolpe/nix-config
   homeManagerDarwinModules = {
     # https://github.com/malob/nixpkgs
     colors = import ./modules/home/colors;
     my-colors = import ./home/colors.nix;
     my-kitty = import ./home/kitty.nix;
     my-fish = import ./modules/home/fish;
     my-starship = import ./home/starship.nix;
     my-starship-symbols = import ./home/starship-symbols.nix;
     my-git = import ./home/git.nix;
     my-tmux = import ./modules/home/tmux;
     my-main = import ./home/main.nix;
     my-neovim = import ./home/neovim-nightly.nix;
     home-user-info = { lib, ... }: {
          # XXX figure what this does
          options.home.user-info = (self.systemModules.users-primaryUser { inherit lib; }).options.users.primaryUser;
        };
   };
   homeManagerLinuxModules = {
     # XXX Only working on linux
     my-mail = import ./modules/home/mail;
     my-neovim = import ./home/neovim.nix;
     programs-neovim-extras = import ./modules/home/programs/neovim/extras.nix;
     my-keybase = import ./home/keybase.nix;
     my-firefox = import ./home/firefox.nix;
     my-i3 = import ./home/i3.nix;
     # XXX working everywhere
     colors = import ./modules/home/colors;
     my-colors = import ./home/colors.nix;
     my-kitty = import ./home/kitty.nix;
     my-fish = import ./modules/home/fish;
     my-starship = import ./home/starship.nix;
     my-starship-symbols = import ./home/starship-symbols.nix;
     my-git = import ./home/git.nix;
     my-tmux = import ./modules/home/tmux;
     my-main = import ./home/main.nix;
     home-user-info = { lib, ... }: {
          # XXX figure what this does
          options.home.user-info = (self.systemModules.users-primaryUser { inherit lib; }).options.users.primaryUser;
        };
   };

    # `nixos` configs
    nixosConfigurations = {
      brutal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # XXX test if we should/can pass nixos-stable
        # pkgs = import nixos-stable {
        # XXX test if really required
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ inputs.nur.overlay ];
        };
        modules = [
          # Main config
          ./machines/brutal/configuration-brutal.nix

          # `home-manager` module
          home-manager.nixosModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            # install packages to /etc/profiles
            home-manager.useUserPackages = true;
            # pass extra args to the modules
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.baptiste = {
              # XXX to be tested
              imports = attrValues self.homeManagerLinuxModules;
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
          ./machines/Baptistes-MBP/configuration-Baptistes-MBP.nix

          # `home-manager` module
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            # install packages to /etc/profiles
            home-manager.useUserPackages = true;
            # pass extra args to the modules
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.baptiste = {
            imports = attrValues self.homeManagerDarwinModules;
             home.stateVersion = homeStateVersion;
             home.user-info = primaryUserDefaults;
             };
          }
        ];
      };
    };

    # `home-manager` configs, for systems not running Nix OS nor Nix Darwin
    # homemManagerConfigurations = {
    #    import ./home-conf.nix {
    #      inherit (inputs) nixpkgs home-manager;
    #      nixosConfigs = inputs.self.nixosConfigurations;
    #    }
    # }
 };
}
