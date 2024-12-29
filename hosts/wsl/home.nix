{ ... }:
{
  imports = [
    ../../home/theme.nix
    ../../home/cli
    ../../home/lang
  ];
  programs.helix.defaultEditor = true;
}
