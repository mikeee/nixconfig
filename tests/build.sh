#!/usr/bin/env bash
set -euo pipefail

NIX_FLAGS=(--extra-experimental-features 'nix-command flakes')
NIX_INPUT_ARGS=()

if [[ -n "${DOTFILES_OVERRIDE_INPUT:-}" ]]; then
  NIX_INPUT_ARGS=(--override-input dotfiles "$DOTFILES_OVERRIDE_INPUT")
elif [[ "${CI:-}" == "true" && -d "./stubs/dotfiles" ]]; then
  NIX_INPUT_ARGS=(--override-input dotfiles path:./stubs/dotfiles)
fi

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

current_system=$(nix "${NIX_FLAGS[@]}" eval --impure --raw --expr builtins.currentSystem "${NIX_INPUT_ARGS[@]}")

rm -f result

for host in "${HOSTS[@]}"; do
  host_system=$(nix "${NIX_FLAGS[@]}" eval --raw ".#nixosConfigurations.${host}.pkgs.stdenv.hostPlatform.system" "${NIX_INPUT_ARGS[@]}" 2>/dev/null || true)

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
    "${NIX_INPUT_ARGS[@]}" \
    --out-link "result-${host}" \
    ".#nixosConfigurations.${host}.config.system.build.toplevel"
  echo "Build for $host succeeded."

  mike_hm_exists=$(nix "${NIX_FLAGS[@]}" eval --raw ".#nixosConfigurations.${host}.config.home-manager.users.mike.home.username" "${NIX_INPUT_ARGS[@]}" 2>/dev/null || true)

  if [[ "$mike_hm_exists" != "mike" ]]; then
    echo "Skipping nvim link check for $host (home-manager user mike not configured)."
    continue
  fi

  echo "Checking Home Manager nvim link for $host..."
  hm_out=$(nix "${NIX_FLAGS[@]}" build --no-link --print-out-paths \
    "${NIX_INPUT_ARGS[@]}" \
    ".#nixosConfigurations.${host}.config.home-manager.users.mike.home.activationPackage")

  nvim_dir="$hm_out/home-files/.config/nvim"
  nvim_init_link="$hm_out/home-files/.config/nvim/init.lua"

  if [[ ! -d "$nvim_dir" ]]; then
    echo "Expected directory missing: $nvim_dir"
    exit 1
  fi

  if [[ ! -L "$nvim_init_link" ]]; then
    echo "Expected symlink missing: $nvim_init_link"
    exit 1
  fi

  echo "nvim link check passed for $host ($nvim_init_link)."
done

echo "All builds succeeded."
