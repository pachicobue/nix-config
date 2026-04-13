{ delib, ... }:
delib.module {
  name = "home.pueue";
  home.always.services.pueue.enable = true;
}
