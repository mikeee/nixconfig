{ config, pkgs, ... }:
{
  programs.git.enable = true;
  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ -t 1 ]]; then
        export GPG_TTY="$(tty)"
      fi
    '';
  };
  programs.neovim.enable = true;
  programs.zsh = {
    enable = true;
    initContent = ''
      if [[ -t 1 ]]; then
        export GPG_TTY="$(tty)"
      fi
    '';
  };
}
