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
      defaultGateway = allowNull (strOption null);
      nameservers = listOfOption str [];
      staticIp = attrsOfOption str {};
    };

  nixos.always = {cfg, ...}: let
    interfaces =
      builtins.mapAttrs (_: value: let
        parts = lib.splitString "/" value;
      in {
        ipv4.addresses = [
          {
            address = builtins.elemAt parts 0;
            prefixLength = lib.toInt (builtins.elemAt parts 1);
          }
        ];
      })
      cfg.staticIp;
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
