{
  description = "Personal NixOS devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # 2026-10-19: removed nix-cachyos-kernel (xddxdd) - maintainer's servers
    # compromised (incl. attic signing key), see repo issue #110
    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      helium,
      nixpkgs-unstable,
      ...
    }:
    let
      mkHost =
        name:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit helium nixpkgs-unstable;
          };
          modules = [
            home-manager.nixosModules.home-manager
            ./modules
            ./hosts/${name}
          ];
        };
    in
    {
      nixosConfigurations.xiaolong = mkHost "xiaolong";
    };
}
