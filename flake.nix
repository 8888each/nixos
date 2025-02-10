{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-yazi-plugins = {
      url = "github:lordkekz/nix-yazi-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system          = "x86_64-linux";
    lib             = nixpkgs.lib;
    pkgs            = import nixpkgs {
      system = system;
      config.allowUnfree = true;
    };
    specialArgs     = { inherit system inputs; };
    extraSpecialArgs = { inherit system inputs; };
  in {
    nixosConfigurations = {
      dev = lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./configuration-common.nix
          ./configuration-vm.nix
          ({ config, pkgs, ... }: {
            networking.hostName = "dev";
            nixpkgs.hostPlatform = system;
          })
        ];
      };

      lenovo = lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./configuration-common.nix
          ./configuration-lenovo.nix
          ({ config, pkgs, ... }: {
            networking.hostName = "lenovo";
            nixpkgs.hostPlatform = system;
          })
        ];
      };
    };

    homeConfigurations = {
      dev = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home-manager/home-common.nix
          ./home-manager/home-vm.nix
        ];
        extraSpecialArgs = extraSpecialArgs;
      };

      lenovo = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home-manager/home-common.nix
          ./home-manager/home-lenovo.nix
        ];
        extraSpecialArgs = extraSpecialArgs;
      };
    };
  };
}
