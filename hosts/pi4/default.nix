{
  delib,
  config,
  pkgs,
  ...
}:
delib.host {
  name = "pi4";
  system = "aarch64-linux";
  type = "server";

  network = {
    staticIp = [
      {
        address = "192.168.10.181";
        prefixLength = 24;
      }
    ];
    nic = [
      {
        name = "eth0";
        mac = "2c:cf:67:1a:1c:61";
      }
    ];
  };

  myconfig = {...}: {
    services = {
      tailscale.enable = true;
      sshd.enable = true;
    };
    deploy.enable = true;
  };

  nixos = {...}: {
    system.stateVersion = "25.05";
    networking = {
      hostName = "pi4";
      nameservers = ["1.1.1.1"];
    };
    nixpkgs.config.allowUnfree = true;

    boot = {
      loader = {
        grub.enable = false;
        generic-extlinux-compatible = {
          enable = true;
          configurationLimit = 3;
        };
        timeout = 3;
      };
    };

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

    containers.adguardhome = {
      autoStart = true;
      config = {...}: {
        system.stateVersion = "25.05";
        imports = [
          ../../container/adguardhome.nix
        ];
      };
      specialArgs = {constants = config.myconfig.constants;};
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

  home = {...}: {
    home.stateVersion = "25.05";
  };
}
