{ ... }:
{
  imports = [
    ../../home/theme.nix
    ../../home/cli
    ../../home/cli/wayland.nix
    ../../home/gui/foot.nix
    ../../home/gui/obsidian.nix
    ../../home/gui/firefox.nix
    # ../../home/gui/mathematica
    ../../home/gui/webcord.nix
    ../../home/desktop/hyprland
    # ../../home/desktop/gnome
    ../../home/lang
  ];
  home.sessionPath = [
    "/home/sho/.cargo/bin"
  ];
  programs.helix.defaultEditor = true;
}
