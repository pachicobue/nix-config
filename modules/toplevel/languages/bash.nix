{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "internal.languages.bash";
  options = delib.singleEnableOption host.languageFeatured;
  # TODO: myconfig.ifEnabled language-servers (WIP)
  home.ifEnabled = {
    home.packages = with pkgs; [
      bash-language-server
    ];
  };
}
