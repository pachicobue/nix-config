{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      moralerspace
    ];
    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif CJK JP"
        ];
        sansSerif = [
          "Noto Sans CJK JP"
        ];
        monospace = [
          "Moralerspace Neon"
          "Moralerspace Radon"
          "Moralerspace Xenon"
          "Moralerspace Argon"
          "Moralerspace Krypton"
          "Noto Sans Mono CJK JP"
        ];
      };
    };
  };
}
