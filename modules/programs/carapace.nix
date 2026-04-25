{delib, ...}:
delib.module {
  name = "programs.carapace";
  options = delib.singleEnableOption true;
  home.ifEnabled = {
    programs.carapace = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
