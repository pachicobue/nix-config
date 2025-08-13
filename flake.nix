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

    stylix.url = "github:danth/stylix";
    helix.url = "github:helix-editor/helix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    my-nix-secret = {
      url = "github:pachicobue/nix-secret";
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
        hostname = "coconut";
        system = "x86_64-linux";
      }
      {
        hostname = "plum";
        system = "x86_64-linux";
      }
    ];
    vms = [
      {
        hostname = "minimal";
        system = "x86_64-linux";
      }
      {
        hostname = "minimal";
        system = "aarch64-linux";
      }
    ];
  in {
    nixosConfigurations =
      builtins.listToAttrs (
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
                (import ./host/${hostname} {inherit hostname;})
                home-manager.nixosModules.home-manager
              ];
            }
          );
        })
        hosts
      )
      // builtins.listToAttrs (
        map ({
          hostname,
          system,
        }: {
          name = "vm/${hostname}";
          value = (
            nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = {inherit inputs;};
              modules = [
                (import ./vm/${hostname}.nix {inherit hostname;})
                home-manager.nixosModules.home-manager
              ];
            }
          );
        })
        vms
      );
    devShells = import ./devshell.nix inputs;
  };
}
