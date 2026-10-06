{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "services.healthchecks-ping";
  # ホストが生きていることを外部の healthchecks.io に定期的に知らせる
  # ping URL は誰でも叩けると偽の生存報告ができてしまうので
  # healthchecks-ping-url シークレットに置く
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {myconfig, ...}: {
    systemd.services.healthchecks-ping = {
      description = "Send heartbeat to healthchecks.io";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      serviceConfig = {
        Type = "oneshot";
        DynamicUser = true;
        LoadCredential = "url:${myconfig.agenix-rekey.secretPaths.healthchecks-ping-url}";
      };
      script = ''
        url=$(< "$CREDENTIALS_DIRECTORY/url")
        ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null "$url"
      '';
    };

    systemd.timers.healthchecks-ping = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = "5min";
      };
    };
  };
}
