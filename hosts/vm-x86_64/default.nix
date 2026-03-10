{ config, pkgs, ... }:
{
  imports = [
    ../vm-shared
    ../../modules/roles/devtools.nix
    ../../modules/roles/desktop.nix
    ../../modules/roles/user-mike.nix
  ];

  networking.hostName = "nixos";

  programs.firefox.enable = true;

  virtualisation.vmware.guest.enable = true;

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

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };
}
