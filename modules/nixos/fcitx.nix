{pkgs, ...}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
      ignoreUserConfig = true;
      settings.globalOptions = {
        Hotkey = {
          ActivateKeys = "0=Henkan";
          DeactivateKeys = "0=Muhenkan";
        };
      };
    };
  };
}
