{ config, lib, pkgs, ... }:
let
  allowedUnfreePackages = [
    "1password"
    "1password-cli"
    "android-studio"
    "antigravity"
    "brave"
    "claude-code"
    "github-copilot-cli"
    "goland"
    "rust-rover"
    "vscode"
    "vscode-extension-github-copilot-chat"
  ];
  hasDesktopSession =
    config.services.xserver.enable
    || config.services.displayManager.gdm.enable
    || config.services.desktopManager.gnome.enable;
in {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.overlays = [
    (import ../../overlays/claude-code.nix)
    (import ../../overlays/github-copilot-cli.nix)
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    let name = lib.getName pkg;
    in builtins.elem name allowedUnfreePackages
      || lib.hasPrefix "android" name
      || lib.hasPrefix "system-image" name
      || builtins.elem name [
        "build-tools"
        "cmake"
        "cmdline-tools"
        "emulator"
        "ndk"
        "platform-tools"
        "platforms"
        "sources"
        "tools"
      ];

  nixpkgs.config.android_sdk.accept_license = true;

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
