{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-lenovo.nix
    ];

  # Bootloader for UEFI.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Graphics configuration for Intel GPU.
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics = {
    enable      = true;
    enable32Bit = true;
    package     = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.mesa.drivers;
    package32   = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.pkgsi686Linux.mesa.drivers;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # Use SDDM with Wayland support.
  services.displayManager.sddm.enable       = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.autoLogin.enable    = true;
  services.displayManager.autoLogin.user      = "lenovo";

  # Define the laptop user.
  users.users.lenovo = {
    isNormalUser = true;
    description  = "lenovo";
    extraGroups  = [ "networkmanager" "wheel" ];
  };

  # Laptop-specific session variables.
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
    NIXOS_OZONE_WL    = "1";  # Enable Wayland for Electron apps.
  };
}
