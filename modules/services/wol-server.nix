{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "services.wol-server";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      # ホスト名 -> MACアドレス の対応表
      devices = attrsOfOption str {};
      # サブネットのブロードキャストアドレス (例: 192.168.0.255)
      # 255.255.255.255への送信はマルチホーム環境で意図しないインターフェースから
      # 送出されうるため、明示的に指定する
      broadcastAddress = strOption "255.255.255.255";
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "wol";
        runtimeInputs = [pkgs.wakeonlan];
        text = ''
          declare -A devices=(
            ${lib.concatStringsSep "\n            " (lib.mapAttrsToList (name: mac: ''["${name}"]="${mac}"'') cfg.devices)}
          )

          if [[ $# -ne 1 ]]; then
            echo "Usage: wol <device-name>" >&2
            echo "Available devices: ''${!devices[*]}" >&2
            exit 1
          fi

          name=$1
          mac=''${devices[$name]:-}

          if [[ -z $mac ]]; then
            echo "Unknown device: $name" >&2
            echo "Available devices: ''${!devices[*]}" >&2
            exit 1
          fi

          exec wakeonlan -i "${cfg.broadcastAddress}" "$mac"
        '';
      })
    ];
  };
}
