{ ... }:
{
  imports = [
    ../../home/theme.nix
    ../../home/cli
    ../../home/gui
    ../../home/desktop/hyprland
    ../../home/lang
  ];
  programs.helix.defaultEditor = true;
  programs.zsh.shellAliases = {
    e = "emacsclient";
  };
}
