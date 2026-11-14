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
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.8.0";
    kimi-code = {
      # Same revision as the current nix profile installation.
      url = "github:MoonshotAI/kimi-code/f8e15c7a9be44fe4e0361a4ce57eaf690e05476a";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      helium,
      nixpkgs-unstable,
      disko,
      nix-flatpak,
      kimi-code,
      ...
    }:
    let
      mkHost =
        name: extraModules:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit helium nixpkgs-unstable;
          };
          modules = [
            home-manager.nixosModules.home-manager
            nix-flatpak.nixosModules.nix-flatpak
            { home-manager.extraSpecialArgs = { inherit kimi-code; }; }
            ./modules
            ./hosts/${name}
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        # Current Btrfs installation. Rebuilds of this target stay unchanged.
        xiaolong = mkHost "xiaolong" [ ./hosts/xiaolong/hardware-configuration.nix ];

        # Clean ZFS installation via disko-install; does not affect xiaolong.
        xiaolong-zfs = mkHost "xiaolong" [
          disko.nixosModules.disko
          ./hosts/xiaolong/disko.nix
          ./hosts/xiaolong/zfs.nix
        ];
      };
    };
}
