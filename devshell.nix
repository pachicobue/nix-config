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
            #!/bin/sh
            if [ $# -eq 0 ]; then
              echo "Usage: switch <hostname>"
              echo "Available hosts: coconut, plum"
              exit 1
            fi

            TARGET_HOSTNAME="$1"
            CURRENT_HOSTNAME=$(hostname)
            if [ "$TARGET_HOSTNAME" != "$CURRENT_HOSTNAME" ]; then
              echo "⚠️  Warning: Target hostname '$TARGET_HOSTNAME' differs from current hostname '$CURRENT_HOSTNAME'"
              echo "   This will apply configuration for '$TARGET_HOSTNAME' to this machine."
              read -p "   Continue? (y/N): " -n 1 -r
              echo
              if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "Aborted."
                exit 1
              fi
            fi

            nh os switch . --hostname "$TARGET_HOSTNAME"
          '')
          (writeScriptBin "qemu-kvm-uefi" ''
            qemu-kvm \
              -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
              "$@"
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
