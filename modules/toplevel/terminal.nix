{
  delib,
  host,
  lib,
  ...
}:
delib.module {
  name = "terminal";
  options = with delib;
    moduleOptions {
      ghostty = {
        enable = boolOption host.guiFeatured;
        defaultTerminal = boolOption false;
      };
      rio = {
        enable = boolOption host.guiFeatured;
        defaultTerminal = boolOption false;
      };
      alacritty = {
        enable = boolOption host.guiFeatured;
        defaultTerminal = boolOption false;
      };
    };

  myconfig.always = {cfg, ...}: {
    programs = {
      ghostty = {
        inherit (cfg.ghostty) enable defaultTerminal;
      };
      rio = {
        inherit (cfg.rio) enable defaultTerminal;
      };
      alacritty = {
        inherit (cfg.alacritty) enable defaultTerminal;
      };
    };
  };

  home.always = {cfg, ...}: {
    assertions = [
      {
        assertion = lib.count (name: cfg.${name}.defaultTerminal) ["ghostty" "rio" "alacritty"] <= 1;
        message = "Select at most one terminal.defaultTerminal.";
      }
    ];
  };
}
