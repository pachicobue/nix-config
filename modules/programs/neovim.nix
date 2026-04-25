{delib, ...}:
delib.module {
  name = "programs.neovim";
  options = delib.singleEnableOption true;
  nixos.ifEnabled = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
