{ config, lib, pkgs, ... }:

let
  cfg = config.modules.niri;
in
{
  options.modules.niri.enable = lib.mkEnableOption "Niri and its system packages";

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      waywallen
      wl-clipboard
      swaybg
    ];
  };
}
