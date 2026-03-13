{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      moralerspace-jpdoc
    ];
    enableDefaultPackages = false;
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif CJK JP"
        ];
        sansSerif = [
          "Noto Sans CJK JP"
        ];
        monospace = [
          "Moralerspace Neon JPDOC"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };
}
