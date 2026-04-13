{ delib, inputs, pkgs, ... }:
delib.host {
  name = "berry";
  system = "x86_64-linux";

  myconfig = { ... }: {
    host.desktop = "none";
    host.network = {
      useDhcp = true;
      iface = {
        name = "enp1s0";
        mac = "68:1d:ef:37:e8:ab";
        enableWol = true;
      };
    };
    tailscale.enable = true;
    deploy.enable = true;
    openssh.enable = true;
    wakeonlan.enable = true;
    helix.enable = true;
  };

  nixos = { ... }: {
    system.stateVersion = "25.05";
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
        bindMounts."/etc/ssh/ssh_host_ed25519_key".isReadOnly = true;
        config = { ... }: {
          system.stateVersion = "25.05";
          age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          imports = [
            inputs.agenix.nixosModules.default
            ../../container/filebrowser.nix
          ];
        };
      };
      mealie = {
        autoStart = true;
        bindMounts."/etc/ssh/ssh_host_ed25519_key".isReadOnly = true;
        config = { ... }: {
          system.stateVersion = "25.05";
          age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          imports = [
            inputs.agenix.nixosModules.default
            ../../container/mealie.nix
          ];
        };
      };
      silverbullet = {
        autoStart = true;
        privateNetwork = false;
        bindMounts."/etc/ssh/ssh_host_ed25519_key".isReadOnly = true;
        config = { ... }: {
          system.stateVersion = "25.05";
          age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          imports = [
            inputs.agenix.nixosModules.default
            ../../container/silverbullet.nix
          ];
        };
      };
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        8081 # filebrowser
        8096 # jellyfin
        9000 # mealie
      ];
    };
  };

  home = { ... }: {
    home.stateVersion = "25.05";
    programs.helix.defaultEditor = true;
  };
}
