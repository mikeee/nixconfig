{ config, pkgs, dotfiles, ... }:
let
  nvimConfigSource = pkgs.runCommand "nvim-config" { } ''
    cp -r ${dotfiles}/.config/nvim "$out"
    chmod -R u+w "$out"
    rm -f "$out/lazy-lock.json"

    awk '
      /require\("lazy"\)\.setup\(\{/ {
        print
        print "  lockfile = vim.fn.stdpath(\"state\") .. \"/lazy-lock.json\",";
        next
      }
      { print }
    ' "$out/lua/config/lazy.lua" > "$out/lua/config/lazy.lua.tmp"
    mv "$out/lua/config/lazy.lua.tmp" "$out/lua/config/lazy.lua"
  '';
  shellAliases = { };
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
  home-manager.backupFileExtension = "backup";
  home-manager.users.mike = {
    home.stateVersion = config.system.stateVersion;
    xdg.configFile."nvim" = {
      source = nvimConfigSource;
      recursive = true;
      force = true;
    };
    home.packages = with pkgs; [ vim git gcc ];
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
      settings = {
        user = {
          name = "Mike Nguyen";
          email = "hey@mike.ee";
        };
        push = {
          autoSetupRemote = true;
        };
      };
    };
    programs.neovim = {
      enable = true;
      withRuby = false;
      withPython3 = false;
    };
    programs.zsh = {
      enable = true;
      inherit shellAliases;
      initContent = gpgInitSnippet;
    };
  };
}