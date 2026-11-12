{ config, lib, ... }:

let
  cfg = config.modules.nix;
in
{
  options.modules.nix.enable = lib.mkEnableOption "common Nix and nixpkgs configuration";

  config = lib.mkIf cfg.enable {
    nixpkgs.config = {
      allowUnfree = true;
    };

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
  };
}
