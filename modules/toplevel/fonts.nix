{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "fonts";
  options = delib.singleEnableOption host.guiFeatured;
  nixos.ifEnabled = {
    fonts = {
      packages = with pkgs; [noto-fonts];
      enableDefaultPackages = false;
      fontDir.enable = true;
    };
  };
}
