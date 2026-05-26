{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "services.obsidianLivesync";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      port = portOption 5984;
      bindAddress = strOption "127.0.0.1";
      adminUser = strOption "admin";
      adminPassFile = pathOption "";
      tailscaleServe = boolOption false;
      tailscaleHttpsPort = portOption 443;
    };

  nixos.ifEnabled = {cfg, ...}: let
    adminIniPath = "/run/couchdb-admin.ini";
  in {
    services.couchdb = {
      enable = true;
      extraConfigFiles = [adminIniPath];

      inherit (cfg) port bindAddress;

      extraConfig = {
        couchdb = {
          single_node = true;
          max_document_size = 50000000;
        };
        chttpd = {
          require_valid_user = true;
          max_http_request_size = 4294967296;
        };
        chttpd_auth = {
          require_valid_user = true;
          authentication_redirect = "/_utils/session.html";
        };
        httpd = {
          "WWW-Authenticate" = ''Basic realm="couchdb"'';
          enable_cors = true;
        };
        cors = {
          origins = "app://obsidian.md,capacitor://localhost,http://localhost";
          credentials = true;
          headers = "accept, authorization, content-type, origin, referer";
          methods = "GET, PUT, POST, HEAD, DELETE";
          max_age = 3600;
        };
      };
    };

    systemd.services.couchdb-admin-setup = {
      description = "Write CouchDB admin credentials from secret";
      before = ["couchdb.service"];
      requiredBy = ["couchdb.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "couchdb-admin-setup" ''
          printf '[admins]\n${cfg.adminUser} = %s\n' \
            "$(cat ${cfg.adminPassFile})" \
            > ${adminIniPath}
          chown root:couchdb ${adminIniPath}
          chmod 640 ${adminIniPath}
        '';
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.tailscaleServe) [cfg.port];

    systemd.services.obsidian-livesync-tailscale-serve = lib.mkIf cfg.tailscaleServe {
      description = "Tailscale HTTPS serve for obsidian-livesync";
      after = ["tailscaled.service" "couchdb.service" "network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStartPre = pkgs.writeShellScript "wait-for-tailscale" ''
          for i in $(seq 30); do
            state=$(${pkgs.tailscale}/bin/tailscale status --json 2>/dev/null | ${pkgs.jq}/bin/jq -r '.BackendState // empty')
            if [ "$state" = "Running" ]; then
              exit 0
            fi
            sleep 2
          done
          echo "Tailscale did not reach Running state within 60 seconds"
          exit 1
        '';
        ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --https ${toString cfg.tailscaleHttpsPort} http://127.0.0.1:${toString cfg.port}";
        ExecStop = "${pkgs.tailscale}/bin/tailscale serve reset";
      };
    };
  };
}
