{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "yubikey";
  options = with delib;
    moduleOptions {
      enable = boolOption host.usbFeatured;
      enableManager = boolOption host.guiFeatured;
    };
  nixos.ifEnabled = {
    services.pcscd.enable = true;
  };
  home.ifEnabled = {cfg, ...}: {
    home.packages = with pkgs; lib.optionals cfg.enableManager [yubikey-manager];
  };
}
