{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin

    common/font.nix
    common/console.nix
    common/nix.nix
    common/locale.nix
    common/direnv.nix
  ];
}
