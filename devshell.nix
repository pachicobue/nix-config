{ pkgs }:
pkgs.mkShell {
  # Add build dependencies
  packages = with pkgs; [
    git
    github-cli
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
