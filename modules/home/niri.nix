{ config, lib, pkgs, ... }:

let
  cfg = config.modules.niri;
in
{
  options.modules.niri.enable = lib.mkEnableOption "Niri user configuration";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      brightnessctl
      playerctl
      swaybg
      rofi
      nwg-panel
      nwg-displays
      nwg-look
      vicinae
      nautilus
    ];

    home.pointerCursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
      gtk.enable = true;
    };

    gtk = {
      enable = true;
      colorScheme = "dark";
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };

    xdg.configFile = {
      "niri/config.kdl".source = ../desktop/niri/config.kdl;
      "nwg-panel/config".source = ./nwg-panel/config;
      "nwg-panel/common-settings.json".source = ./nwg-panel/common-settings.json;
      "nwg-panel/style.css".source = ./nwg-panel/style.css;
    };

    programs.swaylock.enable = true;
    services.mako.enable = true;
    services.swayidle.enable = false;
    services.polkit-gnome.enable = true;
  };
}
