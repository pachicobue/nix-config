{ flake, ... }:
let
  defaultUser = "sho";
in
{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>

    flake.modules.nixos.${defaultUser}
    flake.modules.nixos.common
  ];

  wsl.enable = true;
  wsl.defaultUser = "sho";
}
