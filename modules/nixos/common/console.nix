{pkgs, ...}: {
  # TTY program supports nerdfont
  services.kmscon.enable = true;
  services.kmscon.fonts = [
    {
      name = "Moralerspace Neon NF";
      package = pkgs.moralerspace-nf;
    }
  ];
  catppuccin.tty = {
    enable = true;
  };
}
