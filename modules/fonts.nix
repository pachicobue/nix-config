{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerd-fonts.symbols-only
      # MoralerspaceNF
      "${pkgs.fetchzip {
        url = "https://github.com/yuru7/moralerspace/releases/download/v1.0.2/MoralerspaceNF_v1.0.2.zip";
        sha256 = "0dsf0na17v31sinpm5541kg9gmc7f3dzhyph6gi8ickisp14f6mw";
      }}"
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
          "Moralerspace Neon NF"
          "Moralerspace Radon NF"
          "Moralerspace Xenon NF"
          "Moralerspace Argon NF"
          "Moralerspace Krypton NF"
          "Noto Color Emoji"
        ];
        emoji = [ "Noro Color Emoji" ];
      };
    };
  };
}
