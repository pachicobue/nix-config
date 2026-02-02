{
  inputs,
  commonConfig,
  hostConfig,
  pkgs,
  ...
}: {
  # Tailscale serve configuration for SilverBullet (HTTPS)
  systemd.services.tailscale-serve-silverbullet = {
    description = "Tailscale Serve for SilverBullet";
    after = ["network-online.target" "tailscaled.service" "container@silverbullet.service"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --https=443 http://127.0.0.1:3000";
      ExecStop = "${pkgs.tailscale}/bin/tailscale serve --https=443 off";
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
      config = {...}: {
        system.stateVersion = "${hostConfig.stateVersion.nixos}";
        age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        imports = [
          inputs.agenix.nixosModules.default
          ../../container/filebrowser.nix
        ];
      };
      specialArgs = {
        inherit commonConfig;
        inherit hostConfig;
      };
    };
    miniflux = {
      autoStart = true;
      bindMounts = {
        "/etc/ssh/ssh_host_ed25519_key" = {
          isReadOnly = true;
        };
      };
      config = {...}: {
        system.stateVersion = "${hostConfig.stateVersion.nixos}";
        age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        imports = [
          inputs.agenix.nixosModules.default
          ../../container/miniflux.nix
        ];
      };
      specialArgs = {
        inherit commonConfig;
        inherit hostConfig;
      };
    };
    mealie = {
      autoStart = true;
      bindMounts = {
        "/etc/ssh/ssh_host_ed25519_key" = {
          isReadOnly = true;
        };
      };
      config = {...}: {
        system.stateVersion = "${hostConfig.stateVersion.nixos}";
        age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        imports = [
          inputs.agenix.nixosModules.default
          ../../container/mealie.nix
        ];
      };
      specialArgs = {
        inherit commonConfig;
        inherit hostConfig;
      };
    };
    silverbullet = {
      autoStart = true;
      privateNetwork = false; # Share host network namespace for Tailscale serve
      bindMounts = {
        "/etc/ssh/ssh_host_ed25519_key" = {
          isReadOnly = true;
        };
      };
      config = {...}: {
        system.stateVersion = "${hostConfig.stateVersion.nixos}";
        age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        imports = [
          inputs.agenix.nixosModules.default
          ../../container/silverbullet.nix
        ];
      };
      specialArgs = {
        inherit commonConfig;
        inherit hostConfig;
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8080 # miniflux
      8081 # filebrowser
      8096 # jellyfin
      9000 # mealie
      # silverbullet (3000) は Tailscale serve 経由でのみアクセス
    ];
  };
}
