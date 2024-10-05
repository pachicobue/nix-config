{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "Monaspace" ]; })
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif CJK JP"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans CJK JP"
          "Noto Color Emoji"
        ];
        monospace = [
          "Monaspice Nerd Font"
          "Noto Color Emoji"
        ];
        emoji = [ "Noro Color Emoji"];
      };
    };
  };
}
