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
    gemini-cli
    nodejs
    pinentry-curses
    python3
    vscode
  ];
}
