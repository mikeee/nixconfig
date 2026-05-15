{ ... }:
{
  imports = [
    ../vm-shared
    ../../modules/roles/devtools.nix
    ../../modules/roles/desktop.nix
    ../../modules/roles/mobile-dev.nix
    ../../modules/roles/user-mike.nix
  ];

  networking.hostName = "nixos";

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = false;
  };
}
