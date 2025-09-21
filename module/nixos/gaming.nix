{pkgs, ...}: {
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    fontPackages = with pkgs; [
      noto-fonts-cjk-sans
    ];
  };
}
