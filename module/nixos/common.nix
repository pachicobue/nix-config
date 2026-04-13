{ delib, pkgs, lib, ... }:
delib.module {
  name = "nixos.common";
  nixos.always = { myconfig, ... }: {
    home-manager.useGlobalPkgs = true;

    time.timeZone = "Asia/Tokyo";
    i18n.defaultLocale = "ja_JP.UTF-8";
    environment = {
      shellAliases = {
        e = "$EDITOR";
        rm = "rm -i";
        cp = "cp -i";
      };
      sessionVariables = lib.mkIf (myconfig.host.desktop == "wayland") {
        NIXOS_OZONE_WL = "1";
      };
      systemPackages = with pkgs;
        [
          tealdeer
          fastfetch
          procs
          ripgrep
          fd
          dust
          bottom
          sd
          tailspin
          skim
        ]
        ++ lib.optionals (myconfig.host.desktop != "none") [ wl-clipboard waypipe ];
      pathsToLink = lib.mkIf (myconfig.host.desktop != "none") [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ];
    };
  };
}
