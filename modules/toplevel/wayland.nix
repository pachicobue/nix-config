{
  delib,
  host,
  ...
}:
delib.module {
  name = "wayland";
  options = delib.singleEnableOption host.waylandFeatured;

  home.ifEnabled = {
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  myconfig.ifEnabled = {
    programs.waypipe.enable = true;
    programs.wl-clipboard.enable = true;
  };
}
