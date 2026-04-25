{delib, ...}:
delib.host {
  name = "coconut";
  system = "x86_64-linux";
  rice = "catppuccin-mocha";
  type = "desktop";
  features = [
    "wayland"
    "nvidia"
    "sshServer"
  ];
  network = {
    nic = [
      {
        name = "eno1";
        mac = "08:bf:b8:a5:74:f7";
        wakeOnLan = true;
      }
    ];
    sshPublicKey = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJGjzlH+kjBX98qiZOQ1raIQ2H6CJefEq3c8LO4uSuP sho@coconut"
    ];
  };

  myconfig = {...}: {
    services = {
      login-managers.greetd.backend = "regreet";
      wayland.windowManager.niri.enable = true;
      desktop-shell.noctalia.enable = true;
    };
    programs = {
      jq.enable = true;
      helix.setAsDefaultEditor = true;
    };
    mako.enable = true;
    fuzzel.enable = true;
    zathura.enable = true;
  };

  nixos = {...}: {
    system.stateVersion = "25.05";
    networking.hostName = "coconut";

    boot = {
      loader = {
        grub.enable = false;
        systemd-boot.enable = false;
        limine = {
          enable = true;
          efiSupport = true;
          efiInstallAsRemovable = true;
          maxGenerations = 10;
        };
        timeout = 3;
      };
      tmp.cleanOnBoot = true;
      # aarch64バイナリをQEMUでエミュレーション（Raspberry Pi用ビルドのため）
      binfmt.emulatedSystems = ["aarch64-linux"];
    };
  };

  home = {...}: {
    home.stateVersion = "25.05";
  };
}
