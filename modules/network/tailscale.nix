{ config, lib, pkgs, ... }:

let
  cfg = config.modules.tailscale;
in
{
  options.modules.tailscale.enable = lib.mkEnableOption "Tailscale with local proxy endpoints";

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      interfaceName = "userspace-networking";
      extraDaemonFlags = [
        "--socks5-server=localhost:1055"
        "--outbound-http-proxy-listen=localhost:1056"
      ];
    };
    environment.systemPackages = [ pkgs.tailscale ];
  };
}
