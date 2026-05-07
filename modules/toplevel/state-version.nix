{delib, ...}:
delib.module {
  name = "state-version";
  options = with delib;
    moduleOptions {
      nixos = allowNull (strOption null);
      home = allowNull (strOption null);
    };

  nixos.always = {cfg, ...}: {
    system.stateVersion = cfg.nixos;
  };

  home.always = {cfg, ...}: {
    home.stateVersion = cfg.home;
  };
}
