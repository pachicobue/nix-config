{delib, ...}:
delib.module {
  name = "common";

  myconfig.always = {
    programs = {
      git.enable = true;
      gnupg.enable = true;
      jujutsu.enable = true;
      devenv.enable = true;
      jq.enable = true;
      starship.enable = true;
      zellij.enable = true;
      zsh.enable = true;
    };
    services = {
      sshd.enable = true;
      tailscale.enable = true;
    };
  };
}
