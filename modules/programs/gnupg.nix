{ config, lib, pkgs, ... }:

let
  cfg = config.modules.gnupg;
in
{
  options.modules.gnupg.enable = lib.mkEnableOption "GnuPG agent and pinentry";

  config = lib.mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-all;
    };
    environment.systemPackages = with pkgs; [
      gnupg
      pinentry-all
    ];
  };
}
