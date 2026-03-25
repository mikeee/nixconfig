{ pkgs, ... }:
{
  home-manager.users.mike = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          github.copilot
          github.copilot-chat
        ];
        userSettings = {
          "chat.disableAIFeatures" = false;
          "git.autofetch" = true;
        };
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
  ];
}
