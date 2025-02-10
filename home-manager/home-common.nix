{ config, pkgs, inputs, system, ... }:

{
  # Import additional home modules.
  imports = [
    ./modules/hyprland.nix
    ./modules/shell.nix
    ./modules/spicetify.nix
    ./modules/tmux.nix
    ./modules/yazi.nix
    (inputs.nix-yazi-plugins.legacyPackages.x86_64-linux.homeManagerModules.default)
    inputs.spicetify-nix.homeManagerModules.default
  ];

  # Common session variables.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Common packages.
  home.packages = with pkgs; [
    nautilus
    vlc
    btop
    inputs.zen-browser.packages."${system}".beta
  ];
}
