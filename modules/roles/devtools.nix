{ pkgs, ... }:
let
  copilotChat = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    name = "copilot-chat";
    publisher = "GitHub";
    version = "0.42.0";
    hash = "sha256-iKDRDqQ8qJe2c4SQJBiJLCEtmVmcci6753+I7uH7YVk=";
  };
in
{
  home-manager.users.mike = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          copilotChat
        ];
        userSettings = {
          "chat.disableAIFeatures" = false;
          "git.autofetch" = true;
          "git.alwaysSignOff" = true;
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
    gnumake
    nodejs
    pinentry-gnome3
    python3
    vscodium
  ];
}
