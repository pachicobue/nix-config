{nixpkgs, ...}: let
  # Devshell support for these platforms
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
          github-cli
          nh
          sbctl
          cryptsetup
          (writeScriptBin "switch" ''
            nh os switch . --hostname "$@"
          '')
        ];
      };
    }
  )
