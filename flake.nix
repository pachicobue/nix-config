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
    treefmt-nix.url = "github:numtide/treefmt-nix";

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
    llm-agent = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
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
      # - HomeManagerはStandAlone型にする（非NixOSの運用を見据える）
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
                      desktop = ["cli" "gui" "usb"];
                      laptop = ["cli" "gui" "usb"];
                      server = ["usb"];
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

      imports = with inputs; [
        treefmt-nix.flakeModule
      ];
      systems = import nix-systems;
      #-------------------------------
      # Per-system outputs
      #-------------------------------
      perSystem = {
        system,
        pkgs,
        ...
      }: {
        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
          };
        };
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              git
              gh
              jujutsu
              nh
              helix
              python3Minimal

              inputs.agenix.packages.${system}.default
              inputs.disko.packages.${system}.disko

              # Python script wrappers - Top-level APIs
              (writeScriptBin "switch" ''
                python3 ./scripts/switch.py $@
              '')
            ];
            shellHook = ''
              #!/bin/sh
              if [[ -n "$CI" ]]; then
                if [ -z "$GITHUB_TOKEN" ]; then
                  echo "✅ CI: Using GITHUB_TOKEN for Nix"
                else
                  echo "❌ CI: GITHUB_TOKEN not found"
                  exit 1
                fi
              else
                if ! gh auth status; then
                  echo "❌ Local: Please login github-cli first."
                  exit 1
                fi
                GITHUB_TOKEN=$(gh auth token)
                echo "✅ Local: GitHub authentication configured"
              fi
              export NIX_CONFIG="extra-experimental-features = nix-command flakes
              access-tokens = github.com=$GITHUB_TOKEN"
            '';
          };
        };
      };

      # deploy = import ./deploy.nix args;
      # checks = import ./check.nix args;
    });
}
