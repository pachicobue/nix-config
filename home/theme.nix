{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];
  catppuccin = {
    flavor = "mocha";
    pointerCursor.enable = true;
  };
  i18n.inputMethod.fcitx5.catppuccin.enable = true;

  programs.alacritty.catppuccin.enable = true;
  programs.bat.catppuccin.enable = true;
  programs.bottom.catppuccin.enable = true;
  programs.foot.catppuccin.enable = true;
  programs.git.delta.catppuccin.enable = true;
  programs.kitty.catppuccin.enable = true;
  programs.lazygit.catppuccin.enable = true;
  programs.skim.catppuccin.enable = true;
  programs.starship.catppuccin.enable = true;
  programs.waybar.catppuccin.enable = true;
  programs.zsh.syntaxHighlighting.catppuccin.enable = true;
  programs.hyprlock.catppuccin.enable = true;
  services.mako.catppuccin.enable = true;
  wayland.windowManager.hyprland.catppuccin.enable = true;
}
