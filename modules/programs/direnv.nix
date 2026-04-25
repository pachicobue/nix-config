{delib, ...}:
delib.module {
  name = "programs.direnv";
  options = delib.singleEnableOption true;
  nixos.ifEnabled = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
  };
}
