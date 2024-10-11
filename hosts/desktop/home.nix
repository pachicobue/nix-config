{ ... }:
{
  imports = [
    ../../home/cli
    ../../home/gui
    ../../home/desktop/hyprland
  ];
  services.emacs.defaultEditor = true;
  programs.zsh.shellAliases = {
    e = "emacsclient";
  };
}
