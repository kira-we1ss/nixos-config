{ config, lib, pkgs, ... }:

let
  cfg = config.modules.performance;
in
{
  options.modules.performance.enable = lib.mkEnableOption "CPU scheduling and performance services";

  config = lib.mkIf cfg.enable {
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
    };
    services.scx = {
      enable = true;
      scheduler = "scx_lavd";
    };
    services.tuned.enable = true;
    services.power-profiles-daemon.enable = false;
  };
}
