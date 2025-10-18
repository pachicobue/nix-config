{inputs, ...}: let
  nixos-generators = inputs.nixos-generators;
  flake-utils = inputs.flake-utils;
in
  flake-utils.lib.eachDefaultSystem (system: {
    "minimal-installer-${system}" = nixos-generators.nixosGenerate {
      inherit system;
      modules = [./installer/minimal.nix];
      format = "install-iso";
    };
  })
