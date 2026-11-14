{ config, lib, pkgs, ... }:

let
  cfg = config.modules.niri;
  catppuccinGtk = pkgs.catppuccin-gtk.override {
    variant = "mocha";
    accents = [ "mauve" ];
  };
  catppuccinKvantum = pkgs.catppuccin-kvantum.override {
    variant = "mocha";
    accent = "mauve";
  };
  catppuccinIcons = pkgs.catppuccin-papirus-folders.override {
    flavor = "mocha";
    accent = "mauve";
  };
  kathTheme = import ../desktop/kath-theme.nix { inherit pkgs; };
  kathQmlConfig = pkgs.writeText "KathConfig.qml" ''
    import QtQml

    QtObject {
        property var config: (${kathTheme.configJson})
    }
  '';
  kathMainAdapter = pkgs.writeText "kath-main-adapter.txt" ''
    id: root

    property var config
    property var sddm
  '';
  kathLockConfig = pkgs.runCommand "kath-lock-config" { } ''
    mkdir -p "$out/Components"
    cp ${./kath-lock/shell.qml} "$out/shell.qml"
    cp ${kathQmlConfig} "$out/KathConfig.qml"
    cp ${kathTheme.package}/share/sddm/themes/sddm-astronaut-theme/Main.qml "$out/Main.qml"
    cp -r ${kathTheme.package}/share/sddm/themes/sddm-astronaut-theme/Components/. "$out/Components/"
    cp ${./kath-lock/Components/TextConstants.qml} "$out/Components/TextConstants.qml"
    chmod -R u+w "$out"
    ln -s ${kathTheme.package}/share/sddm/themes/sddm-astronaut-theme/Assets "$out/Assets"
    ln -s ${kathTheme.package}/share/sddm/themes/sddm-astronaut-theme/Backgrounds "$out/Backgrounds"
    ln -s ${kathTheme.package}/share/sddm/themes/sddm-astronaut-theme/Fonts "$out/Fonts"

    # Only adapt SDDM's context to the lock/PAM adapter. Visual QML is upstream.
    substituteInPlace "$out/Main.qml" \
      --replace-fail '    id: root' "$(cat ${kathMainAdapter})"
    substituteInPlace "$out/Components/LoginForm.qml" \
      --replace-fail 'import SddmComponents 2.0 as SDDM' "" \
      --replace-fail 'SDDM.TextConstants' 'TextConstants' \
      --replace-fail 'Layout.preferredHeight: root.height / 54' 'Layout.preferredHeight: 0' \
      --replace-fail 'Layout.maximumHeight: root.height / 54' "$(printf 'Layout.maximumHeight: 0\n        visible: false')"
    sed -i '/^import QtQuick.Controls 2.15$/a import Quickshell' "$out/Components/Input.qml"
    substituteInPlace "$out/Components/Input.qml" \
      --replace-fail 'model: userModel' 'model: []' \
      --replace-fail 'currentIndex: model.lastIndex' 'currentIndex: 0' \
      --replace-fail 'keyboard.capsLock' 'false' \
      --replace-fail 'text: config.ForceLastUser == "true" ? selectUser.currentText : null' 'text: Quickshell.env("USER")' \
      --replace-fail 'sddm.' 'root.sddm.' \
      --replace-fail 'target: sddm' 'target: root.sddm'
    substituteInPlace "$out/Components/SessionButton.qml" \
      --replace-fail 'model: sessionModel' 'model: []' \
      --replace-fail 'currentIndex: model.lastIndex' 'currentIndex: 0'
    substituteInPlace "$out/Components/SystemButtons.qml" \
      --replace-fail 'sddm.' 'root.sddm.'
  '';
in
{
  options.modules.niri.enable = lib.mkEnableOption "Niri user configuration";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      brightnessctl
      playerctl
      swaybg
      rofi
      nwg-panel
      nwg-displays
      nwg-look
      networkmanagerapplet
      vicinae
      nautilus
    ];

    home.pointerCursor = {
      name = "catppuccin-mocha-mauve-cursors";
      package = pkgs.catppuccin-cursors.mochaMauve;
      size = 24;
      gtk.enable = true;
    };

    gtk = {
      enable = true;
      colorScheme = "dark";
      theme = {
        name = "catppuccin-mocha-mauve-standard";
        package = catppuccinGtk;
      };
      gtk4.theme = {
        name = "catppuccin-mocha-mauve-standard";
        package = catppuccinGtk;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = catppuccinIcons;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
      kvantum = {
        enable = true;
        settings.General.theme = "catppuccin-mocha-mauve";
        themes = [ catppuccinKvantum ];
      };
    };

    xdg.configFile = {
      "niri/config.kdl".source = ../desktop/niri/config.kdl;
      "nwg-panel/config".source = ./nwg-panel/config;
      "nwg-panel/common-settings.json".source = ./nwg-panel/common-settings.json;
      "nwg-panel/style.css".source = ./nwg-panel/style.css;
    };

    programs.quickshell = {
      enable = true;
      package = pkgs.quickshell.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ (with pkgs.qt6; [
          qtmultimedia
          qtsvg
          qtvirtualkeyboard
        ]);
      });
      configs.kath-lock = kathLockConfig;
    };

    home.sessionVariables.KATH_ASSETS = "${kathTheme.package}/share/sddm/themes/sddm-astronaut-theme";
    programs.swaylock.enable = false;
    services.swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "top";
        layer-shell = true;
        layer-shell-cover-screen = false;
        cssPriority = "user";
        control-center-margin-top = 6;
        control-center-margin-right = 8;
        control-center-width = 420;
        control-center-height = -1;
        fit-to-screen = false;
        notification-window-width = 420;
        timeout = 5;
        timeout-low = 3;
        timeout-critical = 0;
        transition-time = 200;
        widgets = [
          "inhibitors"
          "title"
          "dnd"
          "notifications"
        ];
      };
      style = ./swaync/style.css;
    };
    services.mako.enable = false;
    services.network-manager-applet.enable = true;
    services.swayidle.enable = false;
    services.polkit-gnome.enable = true;
  };
}
