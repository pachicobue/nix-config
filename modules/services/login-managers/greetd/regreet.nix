{
  delib,
  host,
  ...
}:
delib.module {
  name = "internal.greetd.regreet";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    assertions = [
      {
        assertion = host.waylandFeatured;
        message = "[regreet] Need 'wayland' feature.";
      }
    ];
    programs.regreet = {
      enable = true;
      cageArgs = ["-s" "-m" "last"];
    };
  };
}
