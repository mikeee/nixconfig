{
  description = "Multi-machine NixOS flake with Home Manager, roles, overlays, and CI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }:
    let
      stateVersion = "25.11";
      stateVersionModule = { ... }: {
        system.stateVersion = stateVersion;
      };
    in {
      nixosConfigurations = {
        atlas = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.dell-xps-15-9570
            # To enable the NVIDIA GPU, uncomment the line below and comment out common-gpu-nvidia-disable
            # nixos-hardware.nixosModules.dell-xps-15-9570-nvidia
            nixos-hardware.nixosModules.common-gpu-nvidia-disable
            home-manager.nixosModules.home-manager
            stateVersionModule
            ./hosts/atlas/default.nix
          ];
          specialArgs = { home-manager = home-manager; };
        };
        vm-x86_64 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
            modules = [
              home-manager.nixosModules.home-manager
              stateVersionModule
              ./hosts/vm-x86_64/default.nix
            ];
          specialArgs = { home-manager = home-manager; };
        };
        vm-aarch64 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
            modules = [
              home-manager.nixosModules.home-manager
              stateVersionModule
              ./hosts/vm-aarch64/default.nix
            ];
          specialArgs = { home-manager = home-manager; };
        };
      };
    };
}
