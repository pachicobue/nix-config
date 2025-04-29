{ ... }:
{
  imports = [
    ../../home/theme.nix
    ../../home/cli
    ../../home/cli/wayland.nix
    ../../home/lang
  ];
  home.sessionPath = [
    "/home/sho/.cargo/bin"
  ];
  programs.helix.defaultEditor = true;
}
