{ config, lib, ... }:

let
  cfg = config.modules.docker;
in
{
  options.modules.docker.enable = lib.mkEnableOption "Docker and user access";

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.kweiss.extraGroups = [ "docker" ];
  };
}
