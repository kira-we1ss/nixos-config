{ config, lib, pkgs, ... }:

let
  cfg = config.modules.gaming;
in
{
  options.modules.gaming.enable = lib.mkEnableOption "gaming programs and supporting packages";

  config = lib.mkIf cfg.enable {
    programs.gamemode.enable = true;
    programs.steam.enable = true;
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    users.users.kweiss.extraGroups = [ "gamemode" ];

    environment.systemPackages = with pkgs; [
      steam-devices-udev-rules
      gamemode
      gamescope
      lutris
      libdecor
      wine-staging
      winetricks
      prismlauncher
    ];
  };
}
