{ pkgs }:
pkgs.mkShell {
  # Add build dependencies
  packages = with pkgs; [
    ragenix
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
