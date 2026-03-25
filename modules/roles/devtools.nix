{ lib, config, pkgs, ... }:
let
  allowedUnfreePackages = [ "vscode" "github-copilot" "github-copilot-chat" ];
in {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) allowedUnfreePackages;

  home-manager.users.mike = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        github.copilot
        github.copilot-chat
      ];
      userSettings = {
        "chat.disableAIFeatures" = false;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    bun
    cargo
    clippy
    antigravity
    rust-analyzer
    rustc
    rustfmt
    go
    jetbrains.goland
    jetbrains.rust-rover
    gemini-cli
    nodejs
    pinentry-gnome3
    python3
    vscodium
    vscode
  ];
}
