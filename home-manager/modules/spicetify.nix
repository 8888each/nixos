{ pkgs, inputs, ... }:

let
  # With flakes, we refer to the legacy packages for our system.
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in {
  programs.spicetify = {
    enable = true;
    # List any extensions you want to enable.
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
    # Select a theme and color scheme.
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
    # If you prefer not to install spicetify by default, you can add:
    # dontInstall = true;
  };
}
