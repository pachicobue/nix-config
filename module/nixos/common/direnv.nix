{ delib, ... }:
delib.module {
  name = "nixos.direnv";
  nixos.always.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
}
