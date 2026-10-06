{
  description = "Pachicobue's NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    denix = {
      url = "github:yunfachi/denix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.nix-darwin.follows = "";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-systems.url = "github:nix-systems/default";

    agenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agent = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    claude-plugins-official = {
      url = "github:anthropics/claude-plugins-official";
      flake = false;
    };
  };

  outputs = {
    denix,
    flake-parts,
    nix-systems,
    ...
  } @ inputs: let
    delib = denix.lib;
  in
    flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      # Denix による Nix設定
      # - HomeManagerはNixos Module
      # - Nix Darwinは現状無視
      flake = let
        mkConfigurations = moduleSystem:
          delib.configurations {
            inherit moduleSystem;
            useHomeManagerModule = true;
            homeManagerUser = "sho";
            paths = [./hosts ./modules ./rices];
            specialArgs = {inherit inputs moduleSystem;};
            extensions = with delib.extensions; [
              args
              overlays
              (base.withConfig {
                args.enable = true;
                hosts = {
                  type.types = [
                    "desktop"
                    "laptop"
                    "server"
                    "virtual"
                  ];
                  features = {
                    features = [
                      "wayland"
                      "x11"
                      "nvidia"

                      "wsl2"

                      "cli"
                      "gui"
                      "usb"
                      "bluetooth"
                    ];
                    defaultByHostType = {
                      desktop = ["cli" "gui" "usb" "bluetooth"];
                      laptop = ["cli" "gui" "usb" "bluetooth"];
                      server = [];
                      virtual = [];
                    };
                  };
                };
              })
            ];
          };
      in {
        nixosConfigurations = mkConfigurations "nixos";
        homeConfigurations = mkConfigurations "home";
      };

      #-------------------------------
      # Per-system outputs
      #-------------------------------
      imports = with inputs; [
        treefmt-nix.flakeModule
        agenix-rekey.flakeModule
      ];
      systems = import nix-systems;
      # devShellはdevenv.nix (スタンドアローンのdevenv) で定義
      perSystem = {...}: {
        # このリポジトリのagenix-rekeyシークレットはNixOSレベル(age.secrets)のみで
        # home-manager側では使わないため、homeConfigurationsの収集自体を止める
        # (自動収集はstylix等の追加inputを含まない簡易評価で壊れるため)
        agenix-rekey = {
          # collectHomeManagerConfigurations = false;
          homeConfigurations = {};
        };
        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            taplo.enable = true;
            shfmt.enable = true;
          };
        };
      };
    });
}
