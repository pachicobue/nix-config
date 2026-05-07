{delib, ...}:
delib.module {
  name = "programs.atuin";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.atuin = {
      enable = true;
      daemon.enable = true;
      flags = [
        "--disable-up-arrow"
      ];
    };
  };
}
