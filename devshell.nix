{nixpkgs, ...}: let
  supportedSystems = [
    "x86_64-linux"
    "aarch64-linux"
    # "x86_64-darwin"
    # "aarch64-darwin"
  ];
  forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
in
  forAllSystems (
    system: let
      pkgs = (
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          git
          gh
          nh
          (writeScriptBin "switch" ''
            nh os switch . --hostname "$@"
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
    }
  )
