{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.fcitx5";
  options = delib.singleEnableOption host.guiFeatured;
  home.ifEnabled = {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = host.waylandFeatured;
        addons = with pkgs; [fcitx5-mozc];
        ignoreUserConfig = true;
        settings.globalOptions = {
          GroupOrder = {
            "0" = "Default";
          };
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "mozc";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };
          "Groups/0/Items/1" = {
            Name = "mozc";
            Layout = "";
          };
          Hotkey = {
            ActivateKeys = "0=Henkan";
            DeactivateKeys = "0=Muhenkan";
          };
        };
      };
    };
  };
}
