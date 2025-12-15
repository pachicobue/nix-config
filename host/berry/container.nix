{
  inputs,
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
      };
      specialArgs = {
        inherit commonConfig;
        inherit hostConfig;
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d ${dataDisk}/writefreely 0750 root root -"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      443 # HTTPS (Tailscale Funnel用)
      8080 # writefreely (for container access)
    ];
  };

  # Tailscale Funnel - 公開インターネットに公開
  # WriteFreelyに直接接続（Caddyなしでリバースプロキシ）
  systemd.services.tailscale-funnel = {
    description = "Tailscale Funnel for WriteFreely HTTPS";
    after = ["tailscaled.service" "container@writefreely.service"];
    wants = ["container@writefreely.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/run/current-system/sw/bin/tailscale funnel --bg --https 443 http://127.0.0.1:8080";
      ExecStop = "/run/current-system/sw/bin/tailscale funnel --https 443 off";
    };
  };
}
