{delib, ...}:
delib.host {
  name = "coconut";
  system = "x86_64-linux";
  # rice = "catppuccin-mocha";
  type = "desktop";
  features = [
    "wayland"
    "nvidia"
  ];

  myconfig = {...}: {
    state-version.nixos = "25.05";
    state-version.home = "25.05";
    networking = {useDHCP = true;};
    boot = {
      loader = "limine";
      # aarch64バイナリをエミュレーション（Raspberry Pi用ビルドのため）
      emulatedSystems = ["aarch64-linux"];
    };

    niri.enable = true;
    noctalia-shell.enable = true;

    zen-browser.defaultBrowser = true;
    ghostty.defaultTerminal = true;
  };
}
