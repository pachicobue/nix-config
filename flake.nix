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
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # devenv.root をdirenvから注入するためのダミー入力
    # (.envrc で `--override-input devenv-root file+file://<PWD>` に差し替える)
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };

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
        devenv.flakeModule
      ];
      systems = import nix-systems;
      perSystem = {lib, ...}: {
        # devShell (devenv) — devenv.nix をdevenvモジュールとして読み込む
        # devenv.root は .envrc から devenv-root 入力経由で注入される
        devenv.shells.default = {
          imports = [./devenv.nix];
          # nix flake check 等の純粋評価では PWD も devenv-root も得られず
          # アサーションで落ちるため、評価用にflakeのソースパスをフォールバックとする
          # (devenv-root による注入(優先度100)があればそちらが勝つ)
          devenv.root = lib.mkIf (builtins.getEnv "PWD" == "") (lib.mkOverride 900 (toString ./.));
        };
        # devenv.flakeModuleが勝手に生やすpackages (非推奨のdevenv-up/devenv-test、
        # nix2container入力が無いと評価エラーになるcontainer-*) を出力しない
        packages = lib.mkForce {};
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
