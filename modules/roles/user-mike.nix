{ config, pkgs, ... }:
let
  shellAliases = {
    code = "codium";
  };
  gpgInitSnippet = ''
    if [[ -t 1 ]]; then
      export GPG_TTY="$(tty)"
      gpg-connect-agent updatestartuptty /bye >/dev/null
    fi
  '';
in {
  users.users.mike = {
    isNormalUser = true;
    description = "mike";
    home = "/home/mike";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.zsh.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.mike = {
    home.stateVersion = config.system.stateVersion;
    home.packages = with pkgs; [ vim git ];
    home.sessionVariables.EDITOR = "vim";
    systemd.user.services.gpg-agent-startup-refresh = {
      Unit = {
        Description = "Refresh gpg-agent startup tty/display for GUI pinentry";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.gnupg}/bin/gpg-connect-agent updatestartuptty /bye";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
    programs.bash = {
      enable = true;
      inherit shellAliases;
      initExtra = gpgInitSnippet;
    };
    programs.git = {
      enable = true;
      userName = "mike";
      userEmail = "nix@mike.ee";
    };
    programs.neovim.enable = true;
    programs.zsh = {
      enable = true;
      inherit shellAliases;
      initContent = gpgInitSnippet;
    };
  };
}