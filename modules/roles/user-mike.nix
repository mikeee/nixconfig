{ config, lib, pkgs, dotfiles, ... }:
let
  cfg = config.roles.user-mike;
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
  options.roles.user-mike.linkDotfilesNvim = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Link the Neovim configuration from the external dotfiles input.";
  };

  config = {
    users.users.mike = {
      isNormalUser = true;
      description = "mike";
      home = "/home/mike";
      shell = pkgs.zsh;
      extraGroups = [ "networkmanager" "wheel" "onepassword-cli" ];
    };

    programs.zsh.enable = true;

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";
    home-manager.users.mike = {
      home.stateVersion = config.system.stateVersion;
      xdg.configFile."nvim" = lib.mkIf cfg.linkDotfilesNvim {
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
            signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFIsG3aYMiSKMkWQko0AW2nzl+khUYgZ5eDyJeWFCFCX";
          };
          commit = {
            gpgSign = true;
          };
          gpg = {
            format = "ssh";
          };
          push = {
            autoSetupRemote = true;
          };
          url."git@github.com:" = {
            pushInsteadOf = "https://github.com/";
          };
        };
      };
      programs.neovim = {
        enable = true;
        extraPackages = with pkgs; [ unzip wget ];
        initLua = lib.optionalString (!cfg.linkDotfilesNvim) ''
          require("lazy").setup({})
        '';
        plugins = [ pkgs.vimPlugins.lazy-nvim ];
        withRuby = false;
        withPython3 = false;
      };
      programs.zsh = {
        enable = true;
        inherit shellAliases;
        initContent = gpgInitSnippet;
      };
    };
  };
}