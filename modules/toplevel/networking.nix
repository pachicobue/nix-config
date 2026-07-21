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
    environment.systemPackages = with pkgs; [
      ethtool
    ];
  };
}
