{
  description = "nixos config";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-22.11";
    };

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # I think technically you're not supposed to override the nixpkgs
    # used by neovim but recently I had failures if I didn't pin to my
    # own. We can always try to remove that anytime.
    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , darwin
    , ...
    }@inputs:
    let
      mkDarwin = import ./lib/mkdarwin.nix;
      mkVM = import ./lib/mkvm.nix;

      overlays = [
        #   inputs.neovim-nightly-overlay.overlay
      ];
    in
    {
      nixosConfigurations = {
        vm-aarch64-prl = mkVM "vm-aarch64-prl" {
          inherit overlays nixpkgs home-manager;
          system = "aarch64-linux";
          user = "ben";
        };

        vm-aarch64-utm = mkVM "vm-aarch64-utm" rec {
          inherit overlays nixpkgs home-manager;
          system = "aarch64-linux";
          user = "ben";
        };
      };

      darwinConfigurations = {
        macbook-pro-m1 = mkDarwin "macbook-pro-m1" {
          inherit darwin nixpkgs home-manager overlays;
          system = "aarch64-darwin";
          user = "ben";
        };
      };
    };
}
