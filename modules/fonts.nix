{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      noto-fonts
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
          "MonaspiceNe Nerd Font Mono"
          "MonaspiceRn Nerd Font Mono"
          "MonaspiceXe Nerd Font Mono"
          "MonaspiceAr Nerd Font Mono"
          "Noto Color Emoji"
        ];
        emoji = [ "Noro Color Emoji" ];
      };
    };
  };
}
