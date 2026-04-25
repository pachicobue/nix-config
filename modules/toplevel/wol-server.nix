{
  delib,
  host,
  hosts,
  lib,
  pkgs,
  ...
}: let
  # 各ホストの WOL 有効な nic 一覧 (hostName -> [nic])
  ifaceAttr = lib.filterAttrs (_: nics: nics != []) (
    lib.mapAttrs (_: h: lib.filter (nic: nic.wakeOnLan) h.network.nic) hosts
  );
in
  delib.module {
    name = "wol-server";
    options = delib.singleEnableOption host.wolServerFeatured;
    nixos.ifEnabled = let
      wol-command = pkgs.writeShellScriptBin "wol" ''
        #/bin/sh
        declare -A macs=(
          ${builtins.concatStringsSep "\n      " (lib.flatten (lib.mapAttrsToList (
            hostName: ifaces:
              map (iface: "[${hostName}-${iface.name}]=\"${iface.mac}\"") ifaces
          )
          ifaceAttr))}
        )

        if [ $# -eq 0 ]; then
          echo "Usage: wol <hostname>"
          echo "Available hosts:"
          for host in "''${!macs[@]}"; do
            echo "  - $host: ''${macs[$host]}"
          done
          exit 1
        fi

        hostname="$1"

        if [ -z "''${macs[$hostname]}" ]; then
          echo "Error: Unknown host '$hostname'"
          echo "Available hosts: ''${!macs[*]}"
          exit 1
        fi

        mac="''${macs[$hostname]}"
        echo "Sending Wake-on-LAN packet to $hostname ($mac)..."
        ${pkgs.wakeonlan}/bin/wakeonlan "$mac"
      '';
    in {
      environment.systemPackages = [
        pkgs.ethtool
        pkgs.wakeonlan
        wol-command
      ];
    };
  }
