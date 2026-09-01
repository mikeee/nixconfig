{ lib, pkgs, ... }:
let
  wslSshAgentSocket = "/run/user/1000/wsl2-ssh-agent.sock";
  sshKeygenWithWslAgent = pkgs.writeShellScript "ssh-keygen-wsl-agent" ''
    export SSH_AUTH_SOCK="${wslSshAgentSocket}"
    exec ${pkgs.openssh}/bin/ssh-keygen "$@"
  '';
in
{
  imports = [
    ../common
    ../../modules/roles/devtools.nix
    ../../modules/roles/user-mike.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "mike";
    interop.register = true;
    startMenuLaunchers = true;
    ssh-agent = {
      enable = true;
      users = [ "mike" ];
    };
  };

  networking.hostName = "wsl";

  # usbipd-win's `usbipd attach --wsl` runs modprobe (vhci-hcd) inside WSL.
  # adb itself comes from faceapp's dev shell, not the host.
  environment.systemPackages = [ pkgs.kmod ];

  # Android debugging over usbipd. Current nixpkgs no longer supplies the
  # legacy Android udev rules/group setup, relying on systemd's built-in
  # uaccess tagging instead, but uaccess ACLs only apply to seat-attached
  # logind sessions, which WSL lacks.
  # Grant the standard adbusers group access to devices systemd classifies as
  # Android debug appliances (ADB/Fastboot interface classes).
  # NixOS-WSL defaults services.udev.enable to false; enable it so extraRules
  # are installed (small closure cost, and its module notes it helps usbip).
  services.udev.enable = true;
  users.groups.adbusers = { };
  users.users.mike.extraGroups = [ "adbusers" ];
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ENV{ID_DEBUG_APPLIANCE}=="android", MODE="0660", GROUP="adbusers"
  '';

  roles.user-mike.linkDotfilesNvim = false;

  home-manager.users.mike = {
    home.file.".ssh/github-main.pub".text = ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFIsG3aYMiSKMkWQko0AW2nzl+khUYgZ5eDyJeWFCFCX
    '';
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityAgent = wslSshAgentSocket;
        IdentityFile = "~/.ssh/github-main.pub";
        IdentitiesOnly = true;
      };
    };
    programs.git.settings = {
      gpg.ssh.program = "${sshKeygenWithWslAgent}";
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  console.keyMap = "uk";

  # Docker (from devtools role) is supported under WSL2.
  virtualisation.docker.enableOnBoot = lib.mkForce false;
}
