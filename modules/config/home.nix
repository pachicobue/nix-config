{delib, ...}:
delib.module {
  name = "home";
  home.always = {myconfig, ...}: let
    inherit (myconfig.constants) userName;
  in {
    home = {
      inherit userName;
      homeDirectory = "/home/${userName}";
    };
  };
}
