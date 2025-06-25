{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];
  catppuccin = {
    flavor = "mocha";
    enable = true;
  };
  catppuccin.cursors.enable = true;
  catppuccin.atuin.enable = false;
  catppuccin.helix.enable = false;
}
