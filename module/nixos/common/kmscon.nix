{ delib, ... }:
delib.module {
  name = "nixos.kmscon";
  nixos.always.services.kmscon.enable = true;
}
