{
  system,
  inputs,
  pkgs,
  ...
}: {
  default = pkgs.mkShell {
    packages = with pkgs; [
      git
      gh
      jujutsu
      nh
      helix
      nil
      nixd
      alejandra
      python3Minimal

      inputs.agenix.packages.${system}.default
      inputs.disko.packages.${system}.disko

      # Python script wrappers - Top-level APIs
      (writeScriptBin "switch" ''
        python3 ./script/switch.py $@
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
