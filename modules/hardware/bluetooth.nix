{ config, lib, pkgs, ... }:

let
  cfg = config.modules.bluetooth;
in
{
  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    environment.systemPackages = with pkgs; [
      blueman
    ];

    services.blueman.enable = true;
  };
}
