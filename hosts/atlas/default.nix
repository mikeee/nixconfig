{ ... }:
{
  imports = [
    ../common
    ../../modules/roles/devtools.nix
    ../../modules/roles/desktop.nix
    ../../modules/roles/mobile-dev.nix
    ../../modules/roles/user-mike.nix
  ];

  networking.hostName = "atlas";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Basic file system config for the XPS 9570
  fileSystems."/" = {
    device = "/dev/nvme0n1p2";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };

  # Standard kernel modules for XPS 9570
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];

}
