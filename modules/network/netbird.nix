{
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  ...
}:

let
  cfg = config.modules.netbird;
  unstable = import nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  options.modules.netbird.enable = lib.mkEnableOption "NetBird and its UI";

  config = lib.mkIf cfg.enable {
    services.netbird.enable = true;
    environment.systemPackages = [
      unstable.netbird
      unstable.netbird-ui
    ];
  };
}
