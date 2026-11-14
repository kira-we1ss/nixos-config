{ pkgs, kimi-code, ... }:

{
  modules = {
    fish.enable = true;
    kitty.enable = true;
    niri.enable = true;
    playwright.enable = true;
  };

  home.username = "kweiss";
  home.homeDirectory = "/home/kweiss";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    thunderbird
    qbittorrent
    davinci-resolve
    csview
    gsmartcontrol
    poppler-utils
    scrcpy
    uv
    kimi-code.packages.${pkgs.stdenv.hostPlatform.system}.kimi-code
  ];

  programs.home-manager.enable = true;
}
