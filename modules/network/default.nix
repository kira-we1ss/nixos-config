{ ... }:
{
  imports = [
    ./netbird.nix
    ./tailscale.nix
    # ./static-hosts.nix # Local-only file; restore after reinstall.
  ];
}
