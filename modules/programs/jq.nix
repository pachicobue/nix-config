{
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.jq";
  options = delib.singleEnableOption host.cliFeatured;
  home.ifEnabled = {
    programs.jq.enable = true;
  };
}
