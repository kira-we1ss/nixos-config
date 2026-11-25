# nixos-config

Personal NixOS and nix-darwin configurations.

## Hosts

- `xiaolong` — current NixOS installation (Btrfs).
- `xiaolong-zfs` — clean NixOS installation with ZFS via disko.
- `sunday` — MacBook Air with Apple Silicon (`aarch64-darwin`), nix-darwin and Home Manager.

## macOS: first installation

Install Command Line Tools if they are not already installed:

```sh
xcode-select --install
```

Install Lix, following the [nix-darwin recommendation](https://github.com/nix-darwin/nix-darwin#prerequisites):

```sh
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```

Open a new shell after the installation. From this repository, activate `sunday` for the first time:

```sh
sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake path:/Users/kweiss/Projects/nixos-config#sunday
```

For subsequent changes:

```sh
sudo darwin-rebuild switch --flake path:/Users/kweiss/Projects/nixos-config#sunday
```

Fish provides the same operation as `rebuild`, plus `update` for flake inputs and `cleanup` for old generations.

## Checks without applying changes

Evaluate and build the macOS system closure:

```sh
nix build path:/Users/kweiss/Projects/nixos-config#darwinConfigurations.sunday.system --no-link
```

Show the evaluated flake outputs:

```sh
nix flake show path:/Users/kweiss/Projects/nixos-config
```
