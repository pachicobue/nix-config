{
  description = "Pachicobue's Nix OS configurations.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    catppuccin.url = "github:catppuccin/nix";
    helix.url = "github:helix-editor/helix";

    my-nix-secret = {
      url = "git+ssh://git@github.com/pachicobue/nix-secret.git?shallow=1";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    hosts = [
      {
        hostname = "desktop";
        system = "x86_64-linux";
      }
      {
        hostname = "wsl2";
        system = "x86_64-linux";
      }
    ];
  in {
    nixosConfigurations = builtins.listToAttrs (
      map ({
        hostname,
        system,
      }: {
        name = hostname;
        value = (
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {inherit inputs;};
            modules = [
              (import ./hosts/${hostname} {inherit hostname;})
              home-manager.nixosModules.home-manager
            ];
          }
        );
      })
      hosts
    );

    devShells = import ./devshell.nix inputs;
  };
}
