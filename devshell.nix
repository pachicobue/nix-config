{
  nixpkgs,
  disko,
  ...
}: let
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
          disko.packages.${system}.disko

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
          (writeScriptBin "vm-cleanbuild" ''
            #!/bin/sh
            set -euo pipefail

            if [ $# -eq 0 ]; then
              echo "Usage: vm-cleanbuild <hostname> [size]"
              echo "Available hosts: minimal"
              echo "Default size: 128G"
              exit 1
            fi

            HOSTNAME="$1"
            SIZE="''${2:-128G}"

            echo "🚀 Building VM image for $HOSTNAME..."
            nix build ".#$HOSTNAME"

            echo "📁 Setting up VM result directory..."
            mkdir -p "vm/result"

            echo "📋 Copying QCOW2 image..."
            cp -f result/nixos.qcow2 "vm/result/$HOSTNAME.qcow2"
            chmod 644 "vm/result/$HOSTNAME.qcow2"

            echo "📏 Resizing image to $SIZE..."
            qemu-img resize "vm/result/$HOSTNAME.qcow2" "$SIZE"

            echo "✅ VM image built successfully: vm/result/$HOSTNAME.qcow2 ($SIZE)"
          '')
          (writeScriptBin "vm-run" ''
            #!/bin/sh
            if [ $# -eq 0 ]; then
              echo "Usage: vm-run <hostname> [qemu-options...]"
              echo "Example: vm-run minimal"
              echo "Example: vm-run minimal -nographic -m 8G"
              exit 1
            fi

            HOSTNAME="$1"
            shift

            QCOW_PATH="vm/result/$HOSTNAME.qcow2"
            if [ ! -f "$QCOW_PATH" ]; then
              echo "❌ VM image not found: $QCOW_PATH"
              echo "   Run 'vm-cleanbuild $HOSTNAME' first"
              exit 1
            fi

            BASE_OPTS="-bios ${pkgs.OVMF.fd}/FV/OVMF.fd -hda $QCOW_PATH"

            echo "🚀 Starting VM: $HOSTNAME"
            echo "💻 Command: qemu-kvm $BASE_OPTS $*"
            qemu-kvm $BASE_OPTS "$@"
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
