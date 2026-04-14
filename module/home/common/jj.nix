{ delib, pkgs, ... }:
delib.module {
  name = "home.jj";
  home.always = { myconfig, ... }: {
    programs.jujutsu = {
      enable = true;
      settings = {
        signing = {
          behavior = "drop";
          backend = "gpg";
          key = myconfig.constants.gpg;
        };
        git = {
          "sign-on-push" = true;
        };
        user = {
          name = "pachicobue";
          email = myconfig.constants.userEmail;
        };
      };
    };
    home.packages = [ pkgs.lazyjj ];
  };
}
