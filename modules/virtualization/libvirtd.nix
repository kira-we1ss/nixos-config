{ config, lib, ... }:

let
  cfg = config.modules.libvirtd;
in
{
  options.modules.libvirtd.enable = lib.mkEnableOption "libvirtd with TPM and USB redirection";

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    virtualisation.spiceUSBRedirection.enable = true;
    users.groups.libvirtd.members = [ "kweiss" ];
    users.groups.kvm.members = [ "kweiss" ];
  };
}
