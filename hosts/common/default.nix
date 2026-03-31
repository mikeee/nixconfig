{ config, lib, pkgs, ... }:
let
  allowedUnfreePackages = [
    "antigravity"
    "brave"
    "goland"
    "rust-rover"
    "vscode-extension-github-copilot-chat"
  ];
  hasDesktopSession =
    config.services.xserver.enable
    || config.services.displayManager.gdm.enable
    || config.services.desktopManager.gnome.enable;
in {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) allowedUnfreePackages;

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
