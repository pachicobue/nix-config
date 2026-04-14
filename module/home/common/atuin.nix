{ delib, ... }:
delib.module {
  name = "home.atuin";
  home.always.programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
  };
}
