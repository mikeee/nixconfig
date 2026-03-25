# nixconfig

Multi-machine NixOS flake for NixOS 25.11 with Home Manager, roles, overlays, and CI.

## Hosts
- atlas
- vm-x86_64
- vm-aarch64

Home Manager is enabled for all hosts, including VMs.

If you build multiple hosts in one run, do not rely on the generic `result` symlink. Use a host-specific out-link instead:

```sh
nix --extra-experimental-features 'nix-command flakes' build \
	--out-link result-<host> \
	.#nixosConfigurations.<host>.config.system.build.toplevel
```

The `tests/build.sh` helper already does this, removes any stale generic `result` link, and writes outputs like `result-vm-x86_64`.

## Applying the Flake
To apply the flake to a specific host:

```sh
nixos-rebuild switch --flake github:mikeee/nixconfig#<host>
```
Replace `<host>` with one of the host names above.

## CI
Builds and checks are run via GitHub Actions. See `.github/workflows/ci-upstream-nix.yml`.

## Structure
- `flake.nix`: Flake entrypoint
- `hosts/`: Host configurations
- `modules/packages/`: Package module space (currently empty)
- `modules/roles/`: Role modules
- `tests/`: Build and activation tests
- `.github/workflows/`: CI workflows

## Local Flake Build & Apply

To build and apply your locally written flake for a specific host, use:

```sh
sudo nixos-rebuild switch --flake .#<host>
```
