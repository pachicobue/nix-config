{ delib, ... }:
delib.module {
  name = "home.fastfetch";
  home.always.programs.fastfetch.enable = true;
}
