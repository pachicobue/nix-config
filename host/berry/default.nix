{ delib, inputs, commonConfig, pkgs, ... }:
let
  hostConfig = {
    desktop = "none";
    stateVersion = {
      nixos = "25.05";
      homeManager = "25.05";
    };
    network = {
      useDhcp = true;
      iface = {
        name = "enp1s0";
        mac = "68:1d:ef:37:e8:ab";
        enableWol = true;
      };
    };
  };
in
delib.host {
  name = "berry";
  system = "x86_64-linux";

  nixos = { ... }: {
    _module.args.hostConfig = hostConfig;

    home-manager.extraSpecialArgs = { inherit inputs commonConfig hostConfig; };

    imports = [
      inputs.disko.nixosModules.disko
      ../../hardware/berry/hardware-configuration.nix
      ../../hardware/berry/main-disk-config.nix
      ../../hardware/berry/extra-disk-config.nix

      ../../module/nixos/common.nix
      ../../module/nixos/openssh.nix
      ../../module/nixos/wakeonlan.nix
      ../../module/nixos/tailscale.nix
    ];

    system.stateVersion = hostConfig.stateVersion.nixos;
    networking.hostName = "berry";
    nixpkgs.config.allowUnfree = true;

    boot = {
      loader = {
        grub.enable = false;
        systemd-boot.enable = false;
        limine = {
          enable = true;
          efiSupport = true;
          efiInstallAsRemovable = true;
          maxGenerations = 5;
        };
        timeout = 3;
      };
    };

    # Tailscale serve configuration for HTTPS access (port-based routing)
    systemd.services.tailscale-serve = {
      description = "Tailscale Serve for all services";
      after = [
        "network-online.target"
        "tailscaled.service"
        "container@silverbullet.service"
        "container@mealie.service"
        "container@jellyfin.service"
      ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "tailscale-serve-setup" ''
          # Wait for services to be ready
          for i in {1..30}; do
            ${pkgs.curl}/bin/curl -s http://127.0.0.1:3000 >/dev/null 2>&1 && break
            sleep 1
          done
          for i in {1..30}; do
            ${pkgs.curl}/bin/curl -s http://127.0.0.1:9000 >/dev/null 2>&1 && break
            sleep 1
          done
          for i in {1..30}; do
            ${pkgs.curl}/bin/curl -s http://127.0.0.1:8096 >/dev/null 2>&1 && break
            sleep 1
          done
          for i in {1..30}; do
            ${pkgs.curl}/bin/curl -s http://127.0.0.1:8081 >/dev/null 2>&1 && break
            sleep 1
          done

          # Setup Tailscale serve for all services
          ${pkgs.tailscale}/bin/tailscale serve --bg --https 443 http://127.0.0.1:3000
          ${pkgs.tailscale}/bin/tailscale serve --bg --https 9000 http://127.0.0.1:9000
          ${pkgs.tailscale}/bin/tailscale serve --bg --https 8096 http://127.0.0.1:8096
          ${pkgs.tailscale}/bin/tailscale serve --bg --https 8081 http://127.0.0.1:8081
        '';
        ExecStop = pkgs.writeShellScript "tailscale-serve-teardown" ''
          ${pkgs.tailscale}/bin/tailscale serve reset
        '';
      };
    };

    containers = {
      jellyfin = {
        autoStart = true;
        bindMounts = {
          "/etc/ssh/ssh_host_ed25519_key" = {
            isReadOnly = true;
          };
        };
        config = { ... }: {
          system.stateVersion = hostConfig.stateVersion.nixos;
          age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          imports = [
            inputs.agenix.nixosModules.default
            ../../container/filebrowser.nix
          ];
        };
        specialArgs = { inherit commonConfig hostConfig; };
      };
      mealie = {
        autoStart = true;
        bindMounts = {
          "/etc/ssh/ssh_host_ed25519_key" = {
            isReadOnly = true;
          };
        };
        config = { ... }: {
          system.stateVersion = hostConfig.stateVersion.nixos;
          age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          imports = [
            inputs.agenix.nixosModules.default
            ../../container/mealie.nix
          ];
        };
        specialArgs = { inherit commonConfig hostConfig; };
      };
      silverbullet = {
        autoStart = true;
        privateNetwork = false; # Share host network namespace for Tailscale serve
        bindMounts = {
          "/etc/ssh/ssh_host_ed25519_key" = {
            isReadOnly = true;
          };
        };
        config = { ... }: {
          system.stateVersion = hostConfig.stateVersion.nixos;
          age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          imports = [
            inputs.agenix.nixosModules.default
            ../../container/silverbullet.nix
          ];
        };
        specialArgs = { inherit commonConfig hostConfig; };
      };
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        8081 # filebrowser (HTTP - Tailscale serve経由でHTTPS化)
        8096 # jellyfin (HTTP - Tailscale serve経由でHTTPS化)
        9000 # mealie (HTTP - Tailscale serve経由でHTTPS化)
        # silverbullet (3000) は Tailscale serve 経由でのみアクセス
      ];
    };
  };

  home = { ... }: {
    imports = [
      ../../module/home/common.nix
      ../../module/home/helix.nix
    ];

    home.stateVersion = hostConfig.stateVersion.homeManager;
    programs.helix.defaultEditor = true;
  };
}
