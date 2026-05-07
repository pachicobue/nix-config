{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "networking";
  options = with delib;
    moduleOptions {
      useDHCP = boolOption true;
      defaultGateway = allowNull (strOption null);
      nameservers = listOfOption str [];
    };

  nixos.always = {cfg, ...}: {
    # ネットワーク設定
    networking = {
      hostName = host.name;
      firewall.enable = true;
      inherit (cfg) useDHCP defaultGateway nameservers;
    };
    programs.tcpdump.enable = true;
    environment.systemPackages = with pkgs; [
      ethtool
    ];
  };
}
