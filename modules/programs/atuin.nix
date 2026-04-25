{delib, ...}:
delib.module {
  name = "programs.atuin";
  options = delib.singleEnableOption true;
  home.ifEnabled = {
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      flags = ["--disable-up-arrow"];
    };
  };
}
