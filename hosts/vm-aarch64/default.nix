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
