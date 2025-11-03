{
  lib,
  pkgs,
  hostConfig,
  allHostConfig,
  ...
}: let
  wolHosts =
    builtins.filter (
      host: (host.network.iface.enableWol or false)
    )
    allHostConfig;

  wol-command = pkgs.writeShellScriptBin "wol" ''
    declare -A hosts=(
      ${builtins.concatStringsSep "\n      " (map (
        host: "[${host.name}]=\"${host.network.iface.mac}\""
      )
      wolHosts)}
    )

    if [ $# -eq 0 ]; then
      echo "Usage: wol <hostname>"
      echo "Available hosts:"
      for host in "''${!hosts[@]}"; do
        echo "  - $host: ''${hosts[$host]}"
      done
      exit 1
    fi

    hostname="$1"

    if [ -z "''${hosts[$hostname]}" ]; then
      echo "Error: Unknown host '$hostname'"
      echo "Available hosts: ''${!hosts[*]}"
      exit 1
    fi

    mac="''${hosts[$hostname]}"
    echo "Sending Wake-on-LAN packet to $hostname ($mac)..."
    ${pkgs.wakeonlan}/bin/wakeonlan "$mac"
  '';

  iface = hostConfig.network.iface;
in {
  networking.interfaces = lib.mkIf (builtins.hasAttr "enableWol" iface) {
    ${iface.name}.wakeOnLan = {
      enable = true;
      policy = ["magic"];
    };
  };

  environment.systemPackages = [
    pkgs.ethtool
    pkgs.wakeonlan
    wol-command
  ];
}
