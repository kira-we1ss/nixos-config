{ config, lib, pkgs, ... }:

let
  cfg = config.modules.bluetooth;
in
{
  options.modules.bluetooth.enable = lib.mkEnableOption "Bluetooth module & apps";
  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    environment.systemPackages = with pkgs; [
      blueman
    ];

    services.blueman.enable = true;
  };
}
