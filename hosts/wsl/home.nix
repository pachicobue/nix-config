{ ... }:
{
  imports = [
    ../../home/theme.nix
    ../../home/cli
    ../../home/lang
  ];
  home.sessionPath = [
    "/home/sho/.cargo/bin"
  ];
  programs.helix.defaultEditor = true;
}
