{ inputs, ... }:
let
  defaultUser = "sho";
in
{
  nixpkgs.hostPlatform = "x86_64-linux";
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl.enable = true;
  wsl.defaultUser = "sho";
  wsl.interop.includePath = false;
}
