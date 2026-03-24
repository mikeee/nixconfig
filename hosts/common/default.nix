{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    gnupg
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage =
      if config.services.xserver.enable
      then pkgs.pinentry-gnome3
      else pkgs.pinentry-curses;
  };
}
