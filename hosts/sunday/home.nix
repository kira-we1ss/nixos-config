{ pkgs, unstable, ... }:

{
  modules = {
    fish.enable = true;
    kitty.enable = true;
  };

  home.username = "kweiss";
  home.homeDirectory = "/Users/kweiss";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    csview
    poppler-utils
    qbittorrent
    scrcpy
    thunderbird
    uv
  ];

  programs.omniwm = {
    enable = true;
    package = unstable.omniwm;
    settings = ./omniwm-settings.toml;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;
}
