{
  delib,
  host,
  inputs,
  ...
}:
delib.module {
  name = "wsl2";
  options = with delib;
    moduleOptions {
      enable = boolOption host.wsl2Featured;
    };

  nixos.always = {
    imports = [inputs.nixos-wsl.nixosModules.default];
  };

  nixos.ifEnabled = {myconfig, ...}: {
    networking.resolvconf.enable = false;
    wsl = {
      enable = true;
      defaultUser = myconfig.constants.userName;
    };
  };
}
