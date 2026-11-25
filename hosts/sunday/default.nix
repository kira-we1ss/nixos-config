{
  lib,
  pkgs,
  home-manager-master,
  unstable,
  ...
}:

let
  mtrPacketPath = "/usr/local/libexec/mtr-packet";
in
{
  imports = [
    ../../modules/core/nix.nix
  ];

  modules.nix.enable = true;

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = "kweiss";
  system.stateVersion = 6;

  networking = {
    computerName = "sunday";
    hostName = "sunday";
    localHostName = "sunday";
  };

  time.timeZone = "Europe/Moscow";

  users.users.kweiss = {
    home = "/Users/kweiss";
    shell = pkgs.fish;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.shells = [ pkgs.fish ];

  system.activationScripts.postActivation.text = ''
    /bin/mkdir -p /Library/Preferences/FeatureFlags/Domain
    /usr/bin/defaults write /Library/Preferences/FeatureFlags/Domain/TCC AX_TRANSPARENCY_INDICATOR -dict Enabled -bool false
    /usr/bin/install -d -o root -g wheel -m 0755 /usr/local/libexec
    /usr/bin/install -o root -g wheel -m 4755 ${pkgs.mtr}/bin/mtr-packet ${mtrPacketPath}
  '';

  programs.fish.enable = true;
  programs.gnupg.agent.enable = true;
  programs.ssh.extraConfig = ''
    IdentityAgent ~/.bitwarden-ssh-agent.sock
  '';

  services.netbird.enable = true;
  services.tailscale.enable = true;

  launchd.daemons.tailscaled.command = lib.mkForce ''
    ${lib.getExe' pkgs.tailscale "tailscaled"} \
      --tun=userspace-networking \
      --socks5-server=localhost:1055 \
      --outbound-http-proxy-listen=localhost:1056
  '';

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    sharedModules = [
      ../../modules/home/fish.nix
      ../../modules/home/kitty.nix
      "${home-manager-master}/modules/programs/omniwm.nix"
    ];
    users.kweiss = ./home.nix;
  };

  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  system.defaults.dock = {
    autohide = false;
    show-recents = false;
    mru-spaces = false;
  };
  system.defaults.finder.AppleShowAllFiles = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    departure-mono
    gohufont
    monocraft
  ];

  environment.systemPackages = with pkgs; [
    age
    android-tools
    ansible
    argocd
    bitwarden-desktop
    bun
    cilium-cli
    claude-code
    cloc
    curl
    dig
    dnsutils
    fastfetch
    feishin
    file
    gh
    git
    gnupg
    hyfetch
    jq
    kitty
    kubectl
    kubeseal
    kubernetes-helm
    moonlight-qt
    mtr
    netbird
    nil
    nix-output-monitor
    nixd
    nodejs
    pinentry_mac
    pnpm
    python3
    rsync
    rustlings
    socat
    sops
    ssh-to-age
    tailscale
    unrar
    unzip
    unstable.opencode
    vim
    wget
    whois
    zed-editor
    zip
    (firefox.override {
      appDataDir = "/Users/kweiss/.local/share/firefox";
    })
  ];

  environment.variables = {
    KUBECONFIG = "/Users/kweiss/.kube/config:/Users/kweiss/.kube/config-himeko";
    MTR_PACKET = mtrPacketPath;
  };
}
