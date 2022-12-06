{
  # Inspirations
  description = "Baptiste's systems";

  inputs = {
    # Package sets
    # XXX should we use master as nixpkgs on all systems?
    # nixpkgs.url = "github:NixOS/nixpkgs/master";
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

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    nix2lua.url = "git+https://git.pleshevski.ru/mynix/nix2lua";
  };

  outputs = { self, darwin, nixpkgs, nixpkgs-darwin-stable, home-manager, ... }@inputs:
  let

    inherit (nixpkgs.lib) attrValues;

    homeStateVersion = "22.11";

    # Configuration for `nixpkgs`
    nixpkgsConfig = {
      config = { allowUnfree = true; };
      # overlays = [
      #   inputs.neovim-nightly-overlay.overlay
      #   inputs.nur.overlay
      # ];
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
   homeManagerModules = {
     # https://github.com/malob/nixpkgs
     my-colors = import ./home/colors.nix;
     my-kitty = import ./home/kitty.nix;
     my-fish = import ./home/fish.nix;
     my-starship = import ./home/starship.nix;
     my-starship-symbols = import ./home/starship-symbols.nix;
     my-mail = import ./home/mail.nix;
     my-neovim = import ./home/neovim.nix;
     my-git = import ./home/git.nix;
     my-tmux = import ./home/tmux.nix;
     my-keybase = import ./home/keybase.nix;
     my-firefox = import ./home/firefox.nix;
     my-i3 = import ./home/i3.nix;
     my-main = import ./home/main.nix;

     # Custom modules from gh:malob
     colors = import ./modules/home/colors;
     programs-neovim-extras = import ./modules/home/programs/neovim/extras.nix;
     programs-kitty-extras = import ./modules/home/programs/kitty/extras.nix;
     home-user-info = { lib, ... }: {
          options.home.user-info = (self.systemModules.users-primaryUser { inherit lib; }).options.users.primaryUser;
        };
   };

    # `nixos` configs
    nixosConfigurations = {
      brutal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
        # Includ darwin-sepcific inputs
        inputs = { inherit darwin home-manager nixpkgs nixpkgs-darwin-stable; };
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

    # `home-manager` configs, for systems not running Nix OS nor Nix Darwin
    # homemManagerConfigurations = {
    #    import ./home-conf.nix {
    #      inherit (inputs) nixpkgs home-manager;
    #      nixosConfigs = inputs.self.nixosConfigurations;
    #    }
    # }
 };
}
