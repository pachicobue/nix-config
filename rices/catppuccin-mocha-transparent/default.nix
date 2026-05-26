{delib, ...}:
delib.rice {
  name = "catppuccin-mocha-transparent";
  inherits = ["base" "catppuccin-mocha"];

  myconfig = {...}: {
    niri.transparent = true;
  };
}
