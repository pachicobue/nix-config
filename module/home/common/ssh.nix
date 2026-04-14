{ delib, ... }:
delib.module {
  name = "home.ssh";
  home.always.services.ssh-agent.enable = true;
}
