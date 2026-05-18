{delib, ...}:
delib.module {
  name = "common";

  myconfig.always = {
    programs = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      jujutsu.enable = true;
      starship.enable = true;
      zsh.enable = true;
    };
    services = {
      sshd.enable = true;
      tailscale.enable = true;
    };
  };
}
