{delib, ...}:
delib.module {
  name = "services.tailscale";
  options = delib.singleEnableOption false;
  nixos.ifEnabled = {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "client";
      extraUpFlags = ["--ssh"];
    };
    # Tailscale SSH経由のリモートswitch中にtailscaledが再起動されると
    # セッションごと切断されactivationが失敗扱いになるため、switch時は再起動しない
    # (更新は次回の再起動または手動の systemctl restart で反映される)
    systemd.services.tailscaled.restartIfChanged = false;
  };
}
