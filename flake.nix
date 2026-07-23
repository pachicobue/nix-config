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

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell/legacy-v4";
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
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
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
      perSystem = {
        system,
        config,
        pkgs,
        ...
      }: {
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
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nh
              helix
              python3Minimal
              rage

              inputs.disko.packages.${system}.disko
              config.agenix-rekey.package

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
    });
}
