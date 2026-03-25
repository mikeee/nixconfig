{ config, pkgs, ... }:
let
  hasDesktopSession =
    config.services.xserver.enable
    || config.services.displayManager.gdm.enable
    || config.services.desktopManager.gnome.enable;
in {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    gnupg
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage =
      if hasDesktopSession
      then pkgs.pinentry-gnome3
      else pkgs.pinentry-curses;
  };
}
