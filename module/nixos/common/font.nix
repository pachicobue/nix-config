{pkgs, ...}: let
  size = 12;
in {
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      moralerspace
    ];
  };
  stylix.fonts = {
    serif = {
      package = pkgs.noto-fonts-cjk-serif;
      name = "Noto Serif CJK JP";
    };
    sansSerif = {
      package = pkgs.noto-fonts-cjk-sans;
      name = "Noto Sans CJK JP";
    };
    monospace = {
      package = pkgs.moralerspace;
      name = "Moralerspace Neon";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
    sizes = {
      applications = size;
      desktop = size;
      popups = size;
      terminal = size;
    };
  };
  stylix.targets.fontconfig.enable = true;
}
