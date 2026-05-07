{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.dolphin";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    home.packages = with pkgs; [
      kdePackages.dolphin
      kdePackages.dolphin-plugins
      kdePackages.ark
      kdePackages.kio
    ];
    xdg.mimeApps.defaultApplications = {
      "inode/directory" = ["${pkgs.kdePackages.dolphin}/share/applications/org.kde.dolphin.desktop"];
    };
  };
}
