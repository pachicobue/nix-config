{pkgs, ...}: let
  size = 12;
in {
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.monaspace
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
      package = pkgs.nerd-fonts.monaspace;
      name = "Monaspace Neon";
    };
    emoji = {
      package = pkgs.noto-fonts-color-emoji;
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
