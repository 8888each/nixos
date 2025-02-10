{ config, pkgs, inputs, ... }:

{
  # Enable experimental features.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking.
  networking.networkmanager.enable = true;

  # Time zone and locales.
  time.timeZone = "America/Anchorage";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS         = "en_US.UTF-8";
    LC_IDENTIFICATION  = "en_US.UTF-8";
    LC_MEASUREMENT     = "en_US.UTF-8";
    LC_MONETARY        = "en_US.UTF-8";
    LC_NAME            = "en_US.UTF-8";
    LC_NUMERIC         = "en_US.UTF-8";
    LC_PAPER           = "en_US.UTF-8";
    LC_TELEPHONE       = "en_US.UTF-8";
    LC_TIME            = "en_US.UTF-8";
  };

  # X11 settings.
  services.xserver.enable = true;

  services.xserver.xkb = {
    layout = "us,ru";          # Specifies US and Russian layouts
    variant = ",";             # No specific variants
    options = "grp:win_space_toggle";  # Sets Win+Space to toggle layouts
  };

  # Hyprland & Foot.
  programs.hyprland.enable = true;
  programs.foot = {
    enable = true;
    settings = { main = { font = "Hack Nerd Font:size=14"; }; };
  };

  # NerdFonts, might change later.
  fonts.packages = builtins.concatLists [
    (builtins.filter pkgs.lib.isDerivation (builtins.attrValues pkgs.nerd-fonts))
    (with pkgs; [ inter ])
  ];

  # System packages.
  environment.systemPackages = with pkgs; [
    git wget jq zsh tmux kitty dolphin wofi hyprpaper waybar wl-clipboard firefox nvchad
  ];

  # NVChad overlay.
  nixpkgs.overlays = [
    (final: prev: {
      nvchad = inputs.nvchad4nix.packages."${pkgs.system}".nvchad;
    })
  ];

  # Printing and sound.
  services.printing.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
  };

  # OpenSSH.
  services.openssh.enable = true;

  # System state version.
  system.stateVersion = "24.11";
}
