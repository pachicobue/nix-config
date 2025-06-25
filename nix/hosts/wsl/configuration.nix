{ inputs, flake, ... }:
let
  defaultUser = "sho";
in
{
  nixpkgs.hostPlatform = "x86_64-linux";
  imports = [
    # include NixOS-WSL modules
    inputs.nixos-wsl.nixosModules.default

    flake.modules.nixos.${defaultUser}
    flake.modules.nixos.common
  ];

  wsl.enable = true;
  wsl.defaultUser = "sho";
  wsl.interop.includePath = false;
}
