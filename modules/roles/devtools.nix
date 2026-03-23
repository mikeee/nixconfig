{ config, pkgs, ... }:
{
  home-manager.users.mike = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
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
    pinentry-curses
    python3
    vscodium
    vscode
  ];
}
