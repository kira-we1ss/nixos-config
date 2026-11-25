{
  description = "Personal NixOS and nix-darwin devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-master = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
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
    bootvine = {
      url = "git+https://codeberg.org/wvhulle/bootvine";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kimi-code = {
      # Same revision as the current nix profile installation.
      url = "github:MoonshotAI/kimi-code/f8e15c7a9be44fe4e0361a4ce57eaf690e05476a";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      home-manager-master,
      helium,
      nixpkgs-unstable,
      disko,
      nix-flatpak,
      kimi-code,
      bootvine,
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
            bootvine.nixosModules.default
            { home-manager.extraSpecialArgs = { inherit kimi-code; }; }
            ./modules
            ./hosts/${name}
          ] ++ extraModules;
        };

      mkDarwin =
        name:
        let
          unstable = import nixpkgs-unstable {
            system = "aarch64-darwin";
            config.allowUnfree = true;
          };
        in
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit home-manager-master kimi-code unstable;
          };
          modules = [
            home-manager.darwinModules.home-manager
            { home-manager.extraSpecialArgs = { inherit kimi-code unstable; }; }
            ./hosts/${name}
          ];
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

      darwinConfigurations.sunday = mkDarwin "sunday";
    };
}
