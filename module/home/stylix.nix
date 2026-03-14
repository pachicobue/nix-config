{pkgs, ...}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
    targets.noctalia-shell.enable = false;
    targets.firefox.profileNames = ["default"];
  };
}
