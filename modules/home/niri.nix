{ config, lib, pkgs, ... }:

let
  cfg = config.modules.niri;
in
{
  options.modules.niri.enable = lib.mkEnableOption "Niri user configuration";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      swaybg
      rofi
      nwg-panel
      nwg-displays
      nwg-look
      vicinae
    ];

    xdg.configFile."niri/config.kdl".source = ../desktop/niri/config.kdl;

    programs.swaylock.enable = true;
    services.mako.enable = true;
    services.swayidle.enable = true;
    services.polkit-gnome.enable = true;
  };
}
