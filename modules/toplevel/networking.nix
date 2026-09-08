{
  delib,
  host,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "networking";
  options = with delib;
    moduleOptions {
      useDHCP = boolOption true;

      # DHCP無効なサーバーでの設定
      nameservers = listOfOption str [];
      defaultGateway = allowNull (strOption null);
      staticIpv4 = attrsOfOption str {};
      # ULA (Unique Local Address) 等、既存のDHCP/SLAACに追加するIPv6静的アドレス
      staticIpv6 = attrsOfOption str {};
      # Wake-on-LANでの起動を受け付けるか (要BIOS/UEFI側の対応する設定)
      wakeOnLan = boolOption false;
    };

  nixos.always = {cfg, ...}: let
    parseAddr = value: let
      parts = lib.splitString "/" value;
    in {
      address = builtins.elemAt parts 0;
      prefixLength = lib.toInt (builtins.elemAt parts 1);
    };
    interfacesV4 =
      builtins.mapAttrs (_: value: {ipv4.addresses = [(parseAddr value)];})
      cfg.staticIpv4;
    interfacesV6 =
      builtins.mapAttrs (_: value: {ipv6.addresses = [(parseAddr value)];})
      cfg.staticIpv6;
    interfaces = lib.recursiveUpdate interfacesV4 interfacesV6;
  in {
    # ネットワーク設定
    networking = {
      hostName = host.name;
      firewall.enable = true;
      inherit (cfg) useDHCP defaultGateway nameservers;
      inherit interfaces;
    };
    programs.tcpdump.enable = true;
    environment.systemPackages = with pkgs;
      [
        # リンク層・NICドライバの状態確認
        ethtool
        # 経路ごとの遅延・パケットロスを継続表示 (断続的な切断の切り分けに最適)
        mtr
        # DNS障害の切り分け (dig / nslookup / doggo)
        dnsutils
        doggo
        # スループット実測 (一方を `iperf3 -s` にして計測)
        iperf3
        # ポート・宛先別の帯域使用量
        iftop
        # プロセス別の帯域使用量
        nethogs
        bandwhich
        # LAN上のホスト探索・ポート確認 (IP衝突や不明機器の調査)
        nmap
      ]
      # 無線を使うホストのみ: 電波強度・リンク状態の監視
      ++ lib.optionals host.isLaptop [
        iw
        wavemon
      ];

    # インターフェース名を問わず、有線NIC全体にWoLのmagic packet受信を許可する
    systemd.network.links = lib.mkIf cfg.wakeOnLan {
      "50-wake-on-lan" = {
        matchConfig.Type = "ether";
        linkConfig.WakeOnLan = "magic";
      };
    };
  };
}
