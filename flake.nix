{
  description = "Multi-machine NixOS flake with Home Manager, roles, overlays, and CI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    "1password-shell-plugins".url = "github:1Password/shell-plugins";
    dotfiles = {
      url = "git+https://github.com/mikeee/dotfiles.git?ref=main";
      flake = false;
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, nixos-hardware, dotfiles, ... }:
    let
      stateVersion = "25.11";
      stateVersionModule = { ... }: {
        system.stateVersion = stateVersion;
      };
      mkHost = { system, modules }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit dotfiles;
            onepassword-shell-plugins = inputs."1password-shell-plugins";
          };
          modules = [
            home-manager.nixosModules.home-manager
            stateVersionModule
          ] ++ modules;
        };
    in {
      nixosConfigurations = {
        atlas = mkHost {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.dell-xps-15-9570
            # To enable the NVIDIA GPU, uncomment the line below and comment out common-gpu-nvidia-disable
            # nixos-hardware.nixosModules.dell-xps-15-9570-nvidia
            nixos-hardware.nixosModules.common-gpu-nvidia-disable
            ./hosts/atlas/default.nix
          ];
        };
        vm-x86_64 = mkHost {
          system = "x86_64-linux";
          modules = [
            ./hosts/vm-x86_64/default.nix
          ];
        };
        vm-aarch64 = mkHost {
          system = "aarch64-linux";
          modules = [
            ./hosts/vm-aarch64/default.nix
          ];
        };
      };
    };
}
