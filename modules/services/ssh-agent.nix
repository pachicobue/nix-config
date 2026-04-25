{delib, ...}:
delib.module {
  name = "services.ssh-agent";
  options = delib.singleEnableOption true;
  home.ifEnabled = {
    services.ssh-agent.enable = true;
  };
}
