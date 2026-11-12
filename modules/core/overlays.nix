{ config, lib, ... }:

let
  cfg = config.modules.overlays;
in
{
  options.modules.overlays.enable = lib.mkEnableOption "local package overlays";

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (_: prev: {
        openldap = prev.openldap.overrideAttrs {
          doCheck = !prev.stdenv.hostPlatform.isi686;
        };
        waywallen = prev.callPackage ../../pkgs/waywallen.nix { };
      })
    ];
  };
}
