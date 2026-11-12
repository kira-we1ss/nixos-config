{ config, lib, ... }:

let
  cfg = config.modules.audio;
in
{
  options.modules.audio.enable = lib.mkEnableOption "PipeWire audio";

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
  };
}
