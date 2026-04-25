{
  delib,
  inputs,
  ...
}:
delib.module {
  name = "pkgs";

  nixos.always = {
    nixpkgs.config.allowUnfree = true;
  };
  home.always = {
    nixpkgs.config.allowUnfree = true;
    imports = [inputs.zen-browser.homeModules.default];
  };
}
