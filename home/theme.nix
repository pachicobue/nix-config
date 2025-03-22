{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];
  catppuccin = {
    flavor = "mocha";
  };

  catppuccin.cursors.enable = true;
  catppuccin.fcitx5.enable = true;
  catppuccin.alacritty.enable = true;
  catppuccin.bat.enable = true;
  catppuccin.bottom.enable = true;
  catppuccin.foot.enable = true;
  catppuccin.delta.enable = true;
  catppuccin.kitty.enable = true;
  catppuccin.lazygit.enable = true;
  catppuccin.skim.enable = true;
  catppuccin.starship.enable = true;
  catppuccin.waybar.enable = true;
  catppuccin.zsh-syntax-highlighting.enable = true;
  catppuccin.hyprlock.enable = true;
  catppuccin.mako.enable = true;
  catppuccin.hyprland.enable = true;
  catppuccin.fuzzel.enable = true;
}
