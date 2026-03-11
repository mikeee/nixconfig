{ config, pkgs, ... }:
{
  imports = [
    ../common
    ../../modules/roles/devtools.nix
    ../../modules/roles/desktop.nix
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
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  # Standard kernel modules for XPS 9570
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.mike = {
    imports = [
      ../../home/base/home.nix
    ];
    home.stateVersion = config.system.stateVersion;
    home.packages = with pkgs; [ vim git ];
    programs.bash.enable = true;
    home.sessionVariables = {
      EDITOR = "vim";
    };
  };
}
