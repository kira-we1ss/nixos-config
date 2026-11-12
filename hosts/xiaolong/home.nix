{ pkgs, ... }:

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
  ];

  programs.home-manager.enable = true;
}
