{ lib, appimageTools, fetchurl, nix-update-script }:

let
  version = "0.1.8";
  pname = "waywallen";
  src = fetchurl {
    url = "https://github.com/waywallen/waywallen/releases/download/v${version}/${pname}-${version}-x86_64.AppImage";
    hash = "sha256-OLEJyXTDyWzyyscU8GpwVRlEzhM3zI52ZZL53Unfoew=";
  };
  extracted = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm644 ${extracted}/org.waywallen.waywallen.desktop \
      $out/share/applications/org.waywallen.waywallen.desktop
    install -Dm644 ${extracted}/usr/share/icons/hicolor/scalable/apps/org.waywallen.waywallen.svg \
      $out/share/icons/hicolor/scalable/apps/org.waywallen.waywallen.svg
  '';

  meta = {
    description = "Dynamic wallpaper manager for Linux (Wayland)";
    homepage = "https://github.com/waywallen/waywallen";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "waywallen";
  };

  passthru.updateScript = nix-update-script { };
}
