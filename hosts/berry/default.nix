{
  delib,
  inputs,
  pkgs,
  ...
}:
delib.host {
  name = "berry";
  system = "x86_64-linux";
  type = "server";
  features = [];

  myconfig = {...}: {
    state-version.nixos = "25.05";
    state-version.home = "25.05";
    boot.loader = "limine";
  };

  nixos = {...}: {
    # Tailscale serve configuration for HTTPS access (port-based routing)
    systemd.services.tailscale-serve = {
      description = "Tailscale Serve for all services";
      after = [
        "network-online.target"
        "tailscaled.service"
        "container@jellyfin.service"
      ];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];
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
        config = {...}: {
          system.stateVersion = "25.05";
          age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];
          imports = [
            inputs.agenix.nixosModules.default
            ../../container/filebrowser.nix
          ];
        };
      };
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        8081 # filebrowser
        8096 # jellyfin
      ];
    };
  };
}
