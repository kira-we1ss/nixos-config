{ config, lib, pkgs, ... }:

let
  cfg = config.modules.plasma;
in
{
  options.modules.plasma.enable = lib.mkEnableOption "Plasma 6 and KDE integration";

  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
    programs.kdeconnect.enable = true;
    security.pam.services.kwallet.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.kdeconnect-kde
      kdePackages.partitionmanager
      kdePackages.krdc
      kdePackages.kleopatra
      kdePackages.kcalc
      kdePackages.spectacle
      kdePackages.plasma-workspace
    ];
  };
}
