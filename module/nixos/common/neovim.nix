{ delib, ... }:
delib.module {
  name = "nixos.neovim";
  nixos.always.programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
