#!/usr/bin/env bash
set -e

NIX_FLAGS=(--extra-experimental-features 'nix-command flakes')

HOSTS=()
for host_file in hosts/*/default.nix; do
  host=$(basename "$(dirname "$host_file")")

  case "$host" in
    common|vm-shared)
      continue
      ;;
  esac

  HOSTS+=("$host")
done

current_system=$(nix "${NIX_FLAGS[@]}" eval --impure --raw --expr builtins.currentSystem)

for host in "${HOSTS[@]}"; do
  host_system=$(nix "${NIX_FLAGS[@]}" eval --raw ".#nixosConfigurations.${host}.pkgs.stdenv.hostPlatform.system" 2>/dev/null || true)

  if [[ -z "$host_system" ]]; then
    echo "Skipping $host (no matching nixosConfiguration)."
    continue
  fi

  if [[ "$host_system" != "$current_system" ]]; then
    echo "Skipping $host (target $host_system, current $current_system)."
    continue
  fi

  echo "Building NixOS configuration for $host..."
  nix "${NIX_FLAGS[@]}" build .#nixosConfigurations.$host.config.system.build.toplevel || exit 1
  echo "Build for $host succeeded."
done

echo "All builds succeeded."
