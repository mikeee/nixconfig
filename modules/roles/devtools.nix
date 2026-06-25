{ pkgs, ... }:
let
  copilotChat = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    name = "copilot-chat";
    publisher = "GitHub";
    version = "0.48.1";
    hash = "sha256-eFLfYMFxvgtZtmwLsxfneMjD4jOg8/Uk0Eu/6+A6odY=";
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
    claude-code
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
