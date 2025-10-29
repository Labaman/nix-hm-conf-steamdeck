{
  description = "Home Manager config for Steam Deck with NixGL integration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = { nixpkgs, home-manager, nixgl, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ nixgl.overlay ]; # https://github.com/nix-community/nixGL
      config = {
        allowUnfree = true;
      };
    };
  in {
    homeConfigurations."deck" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./home.nix ];
      # https://nix-community.github.io/home-manager/index.xhtml#sec-usage-gpu-non-nixos
      extraSpecialArgs = { inherit nixgl; };
    };
  };
}
