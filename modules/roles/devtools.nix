{ pkgs, ... }:
let
  copilotChat = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    name = "copilot-chat";
    publisher = "GitHub";
    version = "0.43.2026033101";
    hash = "sha256-ZE94fVoihDHmCXWjGqcTlBH8hJzmK6bwpf4MAFRoM6U=";
  };
in
{
  home-manager.users.mike = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
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
    docker-compose
    rust-analyzer
    rustc
    rustfmt
    go
    github-copilot-cli
    jetbrains.goland
    jetbrains.rust-rover
    gemini-cli
    gnumake
    nodejs
    pinentry-gnome3
    python3
    vscode
    vscodium
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  users.users.mike.extraGroups = [ "docker" ];
}
