{
  config,
  inputs,
  pkgs,
  commonConfig,
  hostConfig,
  ...
}: let
  # /media がメディアデータ用のSecondary Disk
  dataDisk = "/media";
in {
  containers = {
    writefreely = {
      autoStart = true;
      bindMounts = {
        "/etc/ssh/ssh_host_ed25519_key" = {
          hostPath = "/etc/ssh/ssh_host_ed25519_key";
          isReadOnly = true;
        };
        "/var/lib/writefreely" = {
          hostPath = "${dataDisk}/writefreely";
          isReadOnly = false;
        };
      };
      config = {...}: {
        system.stateVersion = "${hostConfig.stateVersion.nixos}";
        age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        imports = [
          inputs.agenix.nixosModules.default
          ../../container/writefreely.nix
        ];
        environment.systemPackages = [
          pkgs.writefreely
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
          hostPath = "/etc/ssh/ssh_host_ed25519_key";
          isReadOnly = true;
        };
        "/var/lib/miniflux" = {
          hostPath = "${dataDisk}/miniflux";
          isReadOnly = false;
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
  };

  systemd.tmpfiles.rules = [
    "d ${dataDisk}/writefreely 0750 root root -"
    "d ${dataDisk}/miniflux 0750 root root -"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8080 # freshrss (for container access)
      8081 # writefreely (for container access)
    ];
  };

  # Cloudflare Tunnel for WriteFreely
  age.secrets."cloudflare/pachicobue-org-tunnel.json" = {
    file = ../../secrets/cloudflare/pachicobue-org-tunnel-json.age;
  };
  services.cloudflared = {
    enable = true;
    tunnels = {
      "pachicobue-writefreely" = {
        credentialsFile = config.age.secrets."cloudflare/pachicobue-org-tunnel.json".path;
        default = "http_status:404";
        ingress = {
          "pachicobue.org" = "http://127.0.0.1:8081";
        };
      };
    };
  };

  # Tailscale Serve for Miniflux
  systemd.services.tailscale-serve = {
    description = "Tailscale Serve for Miniflux";
    after = ["tailscaled.service" "container@miniflux.service"];
    wants = ["container@miniflux.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/run/current-system/sw/bin/tailscale serve --bg --https 443 http://127.0.0.1:8080";
      ExecStop = "/run/current-system/sw/bin/tailscale serve --https 443 off";
    };
  };
}
