{ ... }:
{
  imports = [
    ../vm-shared
    ../../modules/roles/devtools.nix
    ../../modules/roles/desktop.nix
    ../../modules/roles/user-mike.nix
  ];

  networking.hostName = "nixos-arm";

  fileSystems."/" = {
    device = "/dev/nvme0n1p2";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };

  boot.loader.systemd-boot = {
    enable = true;
  };
  
  boot.loader.efi.canTouchEfiVariables = false;
}
