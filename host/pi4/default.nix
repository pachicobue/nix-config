{ delib, inputs, commonConfig, pkgs, ... }:
let
  hostConfig = {
    desktop = "none";
    stateVersion = {
      nixos = "25.05";
      homeManager = "25.05";
    };
    network = {
      useDhcp = false;
      iface = {
        name = "eth0";
        address = "192.168.10.181";
        mac = "2c:cf:67:1a:1c:61";
      };
    };
  };
in
delib.host {
  name = "pi4";
  system = "aarch64-linux";

  nixos = { ... }: {
    _module.args.hostConfig = hostConfig;

    home-manager.extraSpecialArgs = { inherit inputs commonConfig hostConfig; };

    imports = [
      ../../hardware/pi4/hardware-configuration.nix

      ../../module/nixos/common.nix
      ../../module/nixos/openssh.nix
      ../../module/nixos/tailscale.nix
      ../../module/nixos/wakeonlan.nix
    ];

    system.stateVersion = hostConfig.stateVersion.nixos;
    networking = {
      hostName = "pi4";
      nameservers = [ "1.1.1.1" ];
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
      wantedBy = [ "timers.target" ];
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

    containers = {
      adguardhome = {
        autoStart = true;
        config = { ... }: {
          system.stateVersion = hostConfig.stateVersion.nixos;
          imports = [
            ../../container/adguardhome.nix
          ];
        };
        specialArgs = { inherit commonConfig hostConfig; };
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

  home = { ... }: {
    imports = [
      ../../module/home/common.nix
    ];

    home.stateVersion = hostConfig.stateVersion.homeManager;
  };
}
