{ config, pkgs, ... }:
{
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
    programs.bash = {
      enable = true;
      initExtra = ''
        if [[ -t 1 ]]; then
          export GPG_TTY="$(tty)"
        fi
      '';
    };
    programs.git.enable = true;
    programs.neovim.enable = true;
    programs.zsh = {
      enable = true;
      initContent = ''
        if [[ -t 1 ]]; then
          export GPG_TTY="$(tty)"
        fi
      '';
    };
  };
}