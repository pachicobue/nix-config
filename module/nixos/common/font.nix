{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      moralerspace-nf
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
          "Moralerspace Neon NF"
          "Moralerspace Radon NF"
          "Moralerspace Xenon NF"
          "Moralerspace Argon NF"
          "Moralerspace Krypton NF"
          "Noto Sans Mono CJK JP"
        ];
      };
    };
  };
}
