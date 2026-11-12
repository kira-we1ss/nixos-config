{ config, lib, ... }:

let
  cfg = config.modules.home;
in
{
  options.modules.home.enable = lib.mkEnableOption "Home Manager integration";

  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      sharedModules = [
        ./fish.nix
        ./kitty.nix
        ./niri.nix
        ./playwright.nix
      ];
    };
  };
}
