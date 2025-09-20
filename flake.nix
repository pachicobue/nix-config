{
  description = "Pachicobue's Nix OS configurations.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:yaxitech/ragenix";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    stylix.url = "github:danth/stylix";
    helix.url = "github:helix-editor/helix";

    preservation = {
      url = "github:nix-community/preservation";
    };

    my-nix-secret = {
      url = "github:pachicobue/nix-secret";
      flake = false;
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: let
    hosts = [
      {
        hostname = "coconut";
        system = "x86_64-linux";
      }
      {
        hostname = "plum";
        system = "x86_64-linux";
      }
      {
        hostname = "sandbox";
        system = "x86_64-linux";
      }
      {
        hostname = "berry";
        system = "x86_64-linux";
      }
    ];
  in rec {
    nixosConfigurations = builtins.listToAttrs (
      map ({
        hostname,
        system,
      }: {
        name = hostname;
        value = (
          nixpkgs.lib.nixosSystem {
            specialArgs = {inherit inputs;};
            modules = [
              (import ./host/${hostname} {inherit hostname;})
              home-manager.nixosModules.home-manager
            ];
            inherit system;
          }
        );
      })
      hosts
    );

    # Create base VM of `sandbox`
    packages = let
      hostname = "minimal";
      systems = ["x86_64-linux" "aarch64-linux"];
      format = "qcow-efi";
    in
      nixpkgs.lib.genAttrs systems (
        system: {
          ${hostname} = inputs.nixos-generators.nixosGenerate {
            inherit system;
            specialArgs = {inherit inputs;};
            modules = [
              (import ./vm/${hostname}.nix {inherit hostname;})
            ];
            inherit format;
          };
        }
      );

    devShells = import ./devshell.nix inputs;

    deploy.nodes = {
      localhost = {
        hostname = "localhost";
        sshUser = "sho";
        sshOpts = ["-p" "2222"];
        profiles.system = {
          user = "root";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos nixosConfigurations.sandbox;
        };
      };
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks deploy) inputs.deploy-rs.lib;
  };
}
