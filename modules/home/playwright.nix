{ config, lib, pkgs, ... }:

let
  cfg = config.modules.playwright;
in
{
  options.modules.playwright.enable = lib.mkEnableOption "Playwright browser compatibility";

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    };

    home.activation.playwrightBrowsers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p $HOME/.cache/ms-playwright/chromium-1208/chrome-linux
      run ln -sf ${pkgs.playwright-driver.browsers}/chromium-1217/chrome-linux64/chrome \
        $HOME/.cache/ms-playwright/chromium-1208/chrome-linux/chrome
      run mkdir -p $HOME/.cache/ms-playwright/chromium_headless_shell-1208/chrome-headless-shell-linux64
      run ln -sf ${pkgs.playwright-driver.browsers}/chromium_headless_shell-1217/chrome-headless-shell-linux64/chrome-headless-shell \
        $HOME/.cache/ms-playwright/chromium_headless_shell-1208/chrome-headless-shell-linux64/chrome-headless-shell
    '';
  };
}
