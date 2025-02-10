{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-vm.nix
    ];

  # Bootloader for legacy BIOS mode.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";  # Adjust if needed.
  boot.loader.grub.useOSProber = true;

  # Enable VMware guest tools.
  virtualisation.vmware.guest.enable = true;

  # Define the VM user.
  users.users.dev = {
    isNormalUser            = true;
    description             = "dev";
    shell                   = pkgs.zsh;
    ignoreShellProgramCheck = true;
    extraGroups             = [ "networkmanager" "wheel" ];
  };

  # Auto-login for “dev”.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user   = "dev";

  # Disable getty/autovt when using auto-login.
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable  = false;
}
