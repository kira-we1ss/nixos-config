{ config, lib, pkgs, ... }:

let
  cfg = config.modules.fish;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  configPath =
    if isDarwin then "/Users/kweiss/Projects/nixos-config" else "/home/kweiss/Projects/nixos-config";
  rebuildCommand =
    if isDarwin then
      "sudo darwin-rebuild switch --flake path:${configPath}#sunday"
    else
      "sudo nixos-rebuild switch --flake path:${configPath}#xiaolong-zfs";
in
{
  options.modules.fish.enable = lib.mkEnableOption "Fish shell configuration";

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      shellAliases = {
        zed = "zeditor";
        rebuild = "${rebuildCommand} --log-format internal-json -v |& nom --json";
        update = "sudo nix flake update --flake path:${configPath} --log-format internal-json -v |& nom --json";
        cleanup = "sudo nix-collect-garbage -d";
        profile_upgrade = "nix profile upgrade --all --log-format internal-json -v |& nom --json";
      };
      interactiveShellInit = lib.mkAfter ''
        set -u fish_greeting ""
        hyfetch
      '';
    };
  };
}
