{ pkgs, ... }:

{
  boot.kernelModules = [ "ryzen_smu" ];
  systemd.services.amdctl-undervolt = {
    description = "AMD CPU undervolt via amdctl";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for cpu in 0 1 2 3; do
        ${pkgs.amdctl}/bin/amdctl -m -c $cpu -p 0 -v 68
        ${pkgs.amdctl}/bin/amdctl -m -c $cpu -p 1 -v 111
        ${pkgs.amdctl}/bin/amdctl -m -c $cpu -p 2 -v 117
      done
    '';
  };
}
