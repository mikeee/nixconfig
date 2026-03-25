#!/usr/bin/env bash
set -euo pipefail

NIX_FLAGS=(--extra-experimental-features 'nix-command flakes')

declare -a HOSTS=()
shopt -s nullglob

for host_file in hosts/*/default.nix; do
  host=$(basename "$(dirname "$host_file")")

  case "$host" in
    common|vm-shared)
      continue
      ;;
  esac

  HOSTS+=("$host")
done

if [[ ${#HOSTS[@]} -eq 0 ]]; then
  echo "No hosts found under hosts/*/default.nix."
  exit 1
fi

current_system=$(nix "${NIX_FLAGS[@]}" eval --impure --raw --expr builtins.currentSystem)

rm -f result

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
  nix "${NIX_FLAGS[@]}" build \
    --out-link "result-${host}" \
    ".#nixosConfigurations.${host}.config.system.build.toplevel"
  echo "Build for $host succeeded."
done

echo "All builds succeeded."
