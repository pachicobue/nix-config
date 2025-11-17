{inputs, ...}: let
  nixpkgs = inputs.nixpkgs;
  flake-utils = inputs.flake-utils;
in
  builtins.listToAttrs (map (
      system: let
        pkgs = (
          import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          }
        );
      in {
        name = system;
        value = {
          default = pkgs.mkShell {
            packages =
              (with pkgs; [
                git
                gh
                nh
                helix
                python3Minimal
                nil
                alejandra
                deploy-rs

                # Python script wrappers - Top-level APIs
                (writeScriptBin "switch" ''
                  python3 ./script/switch.py $@
                '')
              ])
              ++ [
                inputs.disko.packages.${system}.disko
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
      }
    )
    flake-utils.lib.defaultSystems)
