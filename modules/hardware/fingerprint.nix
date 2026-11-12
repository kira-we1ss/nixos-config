{ config, lib, pkgs, ... }:

let
  cfg = config.modules.fingerprint;
in
{
  options.modules.fingerprint.enable = lib.mkEnableOption "fingerprint authentication";

  config = lib.mkIf cfg.enable {
    services.fprintd.enable = true;
    systemd.services.fprintd.serviceConfig.ExecStart =
      lib.mkForce "${pkgs.fprintd}/libexec/fprintd --timeout -1";
    security.pam.services.polkit-1.fprintAuth = true;
    security.pam.services.sudo.fprintAuth = true;
  };
}
