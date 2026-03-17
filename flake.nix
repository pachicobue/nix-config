{
  description = "Pachicobue's Nix OS configurations.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    denix = {
      url = "github:yunfachi/denix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs @ { ... }: let
    args = { inherit inputs; };
    installerModule = { system }: inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ./installer/minimal.nix ];
    };
  in {
    nixosConfigurations = (inputs.denix.lib.configurations {
      moduleSystem = "nixos";
      homeManagerUser = "sho";
      paths = [ ./host ./module/config ./rice ];
      specialArgs = { inherit inputs; };
      extensions = with inputs.denix.lib.extensions; [ base ];
    }) // {
      "minimal-installer-x86_64-linux" = installerModule { system = "x86_64-linux"; };
      "minimal-installer-aarch64-linux" = installerModule { system = "aarch64-linux"; };
    };
    deploy = import ./deploy.nix args;
    checks = import ./check.nix args;
    devShells = import ./devshell.nix args;
  };
}
