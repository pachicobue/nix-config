{
  delib,
  pkgs,
  ...
}:
delib.host {
  name = "pi4";
  system = "aarch64-linux";
  type = "server";
  features = [];

  myconfig = {...}: {
    state-version.nixos = "25.05";
    state-version.home = "25.05";
    boot.loader = "extlinux";
    networking.useDHCP = false;
  };

  nixos = {...}: {
    networking.interfaces.eth0.ipv4.addresses = [
      {
        address = "192.168.10.181";
        prefixLength = 24;
      }
    ];

    # Reboot per day using systemd timer
    systemd.timers.daily-reboot = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*-*-* 08:00:00";
        Persistent = true;
        Unit = "daily-reboot.service";
      };
    };
    systemd.services.daily-reboot = {
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/systemctl reboot";
      };
      description = "Daily system reboot at 8:00 AM";
    };

    # Containerサービス
    containers.adguardhome = {
      autoStart = true;
      config = {...}: {
        system.stateVersion = "25.05";
        imports = [
          ../../container/adguardhome.nix
        ];
      };
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        53 # DNS
        67 # DHCP
        68 # DHCP
        3000 # AdGuardHome Web UI
      ];
      allowedUDPPorts = [
        53 # DNS
        67 # DHCP
        68 # DHCP
      ];
    };
  };
}
