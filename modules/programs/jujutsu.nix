{delib, ...}:
delib.module {
  name = "programs.jujutsu";
  options = delib.singleEnableOption false;

  home.ifEnabled = {myconfig, ...}: let
    inherit (myconfig.constants) gpg userEmail userHandleName;
  in {
    programs.jujutsu = {
      enable = true;
      settings = {
        signing = {
          behavior = "drop";
          backend = "gpg";
          key = gpg;
        };
        git = {
          sign-on-push = true;
        };
        user = {
          name = userHandleName;
          email = userEmail;
        };
      };
    };
    programs.jjui.enable = true;
  };
}
