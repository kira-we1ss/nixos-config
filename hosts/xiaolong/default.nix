{
  pkgs,
  helium,
  nixpkgs-unstable,
  ...
}:

let
  unstable = import nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ./undervolt.nix
    ./static-hosts.nix
  ];

  modules = {
    nix.enable = true;
    locale.enable = true;
    overlays.enable = true;
    desktop.enable = true;
    niri.enable = true;
    plasma.enable = true;
    audio.enable = true;
    graphics.enable = true;
    fingerprint.enable = true;
    performance.enable = true;
    docker.enable = true;
    libvirtd.enable = true;
    netbird.enable = true;
    tailscale.enable = true;
    gnupg.enable = true;
    gaming.enable = true;
    home.enable = true;
  };

  home-manager.users.kweiss = ./home.nix;

  networking.hostName = "xiaolong";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 2026-10-19: CachyOS kernel removed - xddxdd's infra (incl. attic signing key)
  # compromised, see nix-cachyos-kernel issue #110. Stock nixpkgs kernel instead.
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelModules = [ "msr" ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = [ "aarch64-linux" ];

  boot.kernel.sysctl = {
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    "kernel.sched_latency_ns" = 1000000;
    "kernel.sched_migration_cost_ns" = 500000;
  };

  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.ssh.extraConfig = ''
    IdentityAgent ~/.bitwarden-ssh-agent.sock
  '';
  programs.nix-ld.enable = true;

  services.flatpak.enable = true;
  services.printing.enable = true;
  services.resolved.enable = false;

  users.users.kweiss = {
    isNormalUser = true;
    description = "Kira Weiss";
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
      "video"
      "render"
      "adbusers"
    ];
    shell = pkgs.fish;
  };

  security.sudo.extraRules = [
    {
      users = [ "kweiss" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  environment.systemPackages = with pkgs; [
    wget
    curl
    zed-editor
    bitwarden-desktop
    cifs-utils
    rsync
    vscodium
    claude-code
    unstable.opencode
    git
    dig
    fastfetch
    hyfetch
    gh
    python3
    unzip
    zip
    unrar
    gparted
    binutils
    usbutils
    vim
    file
    android-tools
    refind
    nixd
    nil
    distrobox
    helium.packages.x86_64-linux.default
    cloc
    poedit
    cider-2
    krita
    nix-output-monitor
    socat
    jellyfin-desktop
    jellyfin-rpc
    discord
    bun
    playwright-driver.browsers
    figma-linux
    nodejs
    pnpm
    filezilla
    feishin
    mtr
    whois
    ansible
    amdctl
    stress-ng
    lm_sensors
    ryzenadj
    libreoffice-fresh
    kubectl
    kubernetes-helm
    cilium-cli
    kubeseal
    argocd
    sops
    age
    ssh-to-age
    dnsutils
    jq
    rustlings
    moonlight-qt
    mattermost-desktop
  ];

  environment.sessionVariables.KUBECONFIG = "/home/kweiss/.kube/config:/home/kweiss/.kube/config-himeko";

  system.stateVersion = "26.05";
}
