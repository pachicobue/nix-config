{delib, ...}:
delib.module {
  name = "services.resticServer";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      port = portOption 8000;
    };

  nixos.ifEnabled = {cfg, ...}: {
    # Tailscale 内のホストからしか到達できないようにするため、
    # rest-server 自体の認証 (htpasswd) は使わない
    # リポジトリは ${dataDir}/<name> (デフォルト /var/lib/restic/<name>) に作られる
    services.restic.server = {
      enable = true;
      # systemd socket activation のためポート番号のみを指定する
      listenAddress = toString cfg.port;
      extraFlags = ["--no-auth"];
    };
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [cfg.port];
  };
}
