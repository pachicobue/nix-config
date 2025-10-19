{
  lib,
  pkgs,
  hostConfig,
  allHostConfig,
  ...
}: let
  targetHosts = builtins.filter (host: (host.ethernet != null)) allHostConfig;
  wol-command = pkgs.writeShellScriptBin "wol" ''
    declare -A hosts=(
      ${builtins.concatStringsSep "\n      "
      (map (host: "[${host.name}]=\"${host.ethernet.mac}\"") targetHosts)}
    )

    if [ $# -eq 0 ]; then
      echo "Usage: wol <hostname>"
      echo "Available hosts:"
      for host in "''${!hosts[@]}"; do
        echo "  - $host (''${hosts[$host]})"
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
in {
  networking.interfaces = lib.mkIf (hostConfig.ethernet != null) {
    ${hostConfig.ethernet.name}.wakeOnLan = {
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
