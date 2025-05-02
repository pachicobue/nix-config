{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    fontPackages = with pkgs; [
      noto-fonts-cjk-sans
    ];
  };
  environment.systemPackages = with pkgs; [
    lutris-unwrapped
  ];
}
