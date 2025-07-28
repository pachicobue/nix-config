{ pkgs, ... }:
{
  # TTY program supports nerdfont
  services.kmscon.enable = true;
  services.kmscon.fonts = [
    {
      name = "Moralerspace Neon NF";
      package = pkgs.moralerspace-nf;
    }
  ];
  programs.zsh.enable = true;
  catppuccin.tty = {
    enable = true;
  };
}
