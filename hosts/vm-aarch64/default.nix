{ config, pkgs, ... }:
{
  imports = [
    ../vm-shared
    ../../modules/roles/devtools.nix
    ../../modules/roles/desktop.nix
    ../../modules/roles/user-mike.nix
  ];

  networking.hostName = "nixos-arm";

  programs.firefox.enable = true;


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  fileSystems."/boot" = {
    device = "/dev/vda15";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };
}
