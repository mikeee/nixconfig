{ config, pkgs, ... }:
{
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
    vscode
  ];
}
