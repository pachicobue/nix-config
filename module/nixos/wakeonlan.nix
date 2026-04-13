{ delib, lib, pkgs, ... }:
delib.module {
  name = "wakeonlan";
  options.wakeonlan.enable = delib.boolOption false;
  nixos.ifEnabled = { myconfig, ... }: let
    wolHosts = myconfig.constants.wolHosts;
    iface = myconfig.host.network.iface;
    wol-command = pkgs.writeShellScriptBin "wol" ''
      declare -A hosts=(
        ${builtins.concatStringsSep "\n      " (map (
          host: "[${host.name}]=\"${host.mac}\""
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
  in {
    networking.interfaces = lib.mkIf iface.enableWol {
      ${iface.name}.wakeOnLan = {
        enable = true;
        policy = [ "magic" ];
      };
    };
    environment.systemPackages = [
      pkgs.ethtool
      pkgs.wakeonlan
      wol-command
    ];
  };
}
