{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop;
in
{
  options.modules.desktop.enable = lib.mkEnableOption "common desktop settings";

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.xkb = {
      layout = "us,ru";
      variant = "";
      options = "grp:ctrl_space_toggle";
    };

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      departure-mono
      gohufont
      monocraft
    ];
  };
}
