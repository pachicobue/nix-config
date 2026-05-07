{
  delib,
  host,
  ...
}:
delib.module {
  name = "monitor";
  options = delib.singleEnableOption host.isDesktop;

  myconfig.ifEnabled = {
    programs.ddcutil.enable = true;
  };
}
