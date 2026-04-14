{ delib, ... }:
delib.module {
  name = "nixos.zsh";
  nixos.always.programs.zsh = {
    enable = true;
    enableCompletion = true;
  };
}
