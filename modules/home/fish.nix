{ config, lib, ... }:

let
  cfg = config.modules.fish;
in
{
  options.modules.fish.enable = lib.mkEnableOption "Fish shell configuration";

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      shellAliases = {
        zed = "zeditor";
        rebuild = "sudo nixos-rebuild switch --flake path:/home/kweiss/Projects/nixos-config#xiaolong --log-format internal-json -v |& nom --json";
        update = "sudo nix flake update --flake path:/home/kweiss/Projects/nixos-config --log-format internal-json -v |& nom --json";
        cleanup = "sudo nix-collect-garbage -d";
        profile_upgrade = "nix profile upgrade --all --log-format internal-json -v |& nom --json";
      };
      interactiveShellInit = lib.mkAfter ''
        set -u fish_greeting ""
        fastfetch
      '';
    };
  };
}
