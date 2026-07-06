{delib, ...}:
delib.module {
  name = "programs.nix-search-tv";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.nix-search-tv = {
      enable = true;
      enableTelevisionIntegration = true;
    };
  };
}
