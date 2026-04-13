{ delib, ... }:
delib.module {
  name = "jq";
  options.jq.enable = delib.boolOption false;
  home.ifEnabled.programs.jq.enable = true;
}
