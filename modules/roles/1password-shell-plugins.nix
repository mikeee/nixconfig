{ pkgs, onepassword-shell-plugins, ... }:
{
  imports = [ onepassword-shell-plugins.nixosModules.default ];

  programs._1password-shell-plugins = {
    enable = true;
    plugins = with pkgs; [ gh ];
  };
}
