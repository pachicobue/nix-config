{ pkgs }:
pkgs.mkShell {
  # Add build dependencies
  packages = with pkgs; [
    home-manager
    nix-prefetch-github
    nvfetcher
    (writeScriptBin "switch" ''
      sudo nixos-rebuild switch --flake ".#$@" --show-trace
    '')
  ];

  # Add environment variables
  env = { };

  # Load custom bash code
  shellHook = ''

  '';
}
