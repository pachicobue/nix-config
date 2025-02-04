{ ... }:
{
  imports = [
    ../../home/theme.nix
    ../../home/cli
    ../../home/gui
    ../../home/desktop/hyprland
    # ../../home/desktop/gnome
    ../../home/lang
  ];
  home.sessionPath = [
    "/home/sho/.cargo/bin"
  ];
  programs.helix.defaultEditor = true;
}
