{ pkgs, onepassword-shell-plugins, ... }:
{
  imports = [ onepassword-shell-plugins.nixosModules.default ];

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    brave
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "mike" ];
  };

  programs._1password-shell-plugins = {
    enable = true;
    plugins = with pkgs; [ gh ];
  };
}
