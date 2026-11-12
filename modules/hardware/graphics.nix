{ config, lib, pkgs, ... }:

let
  cfg = config.modules.graphics;
in
{
  options.modules.graphics.enable = lib.mkEnableOption "AMD graphics and ROCm";

  config = lib.mkIf cfg.enable {
    hardware.cpu.amd.updateMicrocode = true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vulkan-validation-layers
        vulkan-extension-layer
        rocmPackages.clr.icd
        rocmPackages.clr
      ];
    };

    systemd.tmpfiles.rules =
      let
        rocmEnv = pkgs.symlinkJoin {
          name = "rocm-combined";
          paths = with pkgs.rocmPackages; [
            rocblas
            hipblas
            clr
          ];
        };
      in
      [ "L+ /opt/rocm - - - - ${rocmEnv}" ];
  };
}
