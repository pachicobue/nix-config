{delib, ...}:
delib.rice {
  name = "transparent";
  inheritanceOnly = true;

  nixos = {
    stylix.opacity = let
      opacity = 0.8;
    in {
      applications = opacity;
      desktop = opacity;
      popups = opacity;
      terminal = opacity;
    };
  };
}
