{delib, ...}:
delib.host {
  name = "coconut";
  system = "x86_64-linux";
  rice = "catppuccin-mocha-transparent";
  type = "desktop";
  features = [
    "wayland"
    "nvidia"
  ];

  myconfig = {...}: {
    agenix-rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYJCBLXavqNCenU0yyAkNMD8fihPVb4H/VqD/Ssa3IP root@coconut";
    state-version.nixos = "25.05";
    state-version.home = "25.05";
    networking = {
      useDHCP = true;
      wakeOnLan = true;
    };
    boot = {
      loader = "limine";
      # aarch64バイナリをエミュレーション（Raspberry Pi用ビルドのため）
      emulatedSystems = ["aarch64-linux"];
    };

    rustdesk.enable = true;

    niri.enable = true;
    noctalia-shell.enable = true;

    zen-browser.defaultBrowser = true;
    ghostty.defaultTerminal = true;
  };
}
