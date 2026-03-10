{
  description = "Multi-machine NixOS flake with Home Manager, roles, overlays, and CI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      stateVersion = "25.11";
      stateVersionModule = { ... }: {
        system.stateVersion = stateVersion;
      };
    in {
      nixosConfigurations = {
        vm-x86_64 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
            modules = [
              home-manager.nixosModules.home-manager
              stateVersionModule
              ./hosts/vm-x86_64/default.nix
            ];
          specialArgs = { home-manager = home-manager; };
        };
      };
    };
}
