{ pkgs, ... }:
{
  users.users.mike = {
    isNormalUser = true;
    description = "mike";
    home = "/home/mike";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.zsh.enable = true;
}