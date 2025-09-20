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
          python3Minimal
          disko.packages.${system}.disko

          # Python script wrappers - Top-level APIs
          (writeScriptBin "switch" ''
            python3 ./script/switch.py $@
          '')
          (writeScriptBin "vm-cleanbuild" ''
            python3 ./script/vm-cleanbuild.py $@
          '')
          (writeScriptBin "vm-runner" ''
            python3 ./script/vm-runner.py $@
          '')
          (writeScriptBin "vm-runner-default" ''
            python3 ./script/vm-runner.py $@ -bios ${OVMF.fd}/FV/OVMF.fd -m 8G -smp 4 -nic user,hostfwd=tcp::2222-:22 -nographic
          '')
          (writeScriptBin "remote-installer" ''
            exec ${pkgs.python3Minimal}/bin/python3 ./script/remote-installer.py $@
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
