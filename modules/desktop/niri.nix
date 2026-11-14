{ config, lib, pkgs, ... }:

let
  cfg = config.modules.niri;
  sddmTheme = (import ./kath-theme.nix { inherit pkgs; }).package;
in
{
  options.modules.niri.enable = lib.mkEnableOption "Niri and its system packages";

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;
    services.displayManager.sddm = {
      theme = "${sddmTheme}/share/sddm/themes/sddm-astronaut-theme";
      extraPackages = [ sddmTheme ];
    };
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      waywallen
      wl-clipboard
      swaybg
    ];
  };
}
