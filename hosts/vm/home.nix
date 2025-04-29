{ ... }:
{
  imports = [
    ../../home/theme.nix
    ../../home/cli
    ../../home/cli/wayland.nix
    ../../home/gui/foot.nix
    ../../home/gui/firefox.nix
    ../../home/desktop/gnome
    ../../home/lang
  ];
  home.sessionPath = [
    "/home/sho/.cargo/bin"
  ];
  programs.helix.defaultEditor = true;
}
