{
  delib,
  host,
  ...
}:
delib.module {
  name = "cli";
  options = delib.singleEnableOption host.cliFeatured;

  myconfig.ifEnabled = {
    programs = {
      atuin.enable = true;
      bottom.enable = true;
      carapace.enable = true;
      claude-code.enable = true;
      fd.enable = true;
      lsd.enable = true;
      procs.enable = true;
      ripgrep.enable = true;
      starship.enable = true;
      tealdeer.enable = true;
      zoxide.enable = true;
      yazi.enable = true;
    };
  };
}
