{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "gaming";
  options = with delib;
    moduleOptions {
      enable = boolOption host.guiFeatured;
    };

  myconfig.ifEnabled = {
    programs.steam.enable = true;
  };

  home.ifEnabled = {
    home.packages = let
      # Noitaのセーブデータ(save00)本体の場所。バックアップ/リストア両コマンドで共通。
      noitaSaveDir = "$HOME/.steam/steam/steamapps/compatdata/881100/pfx/drive_c/users/steamuser/AppData/LocalLow/Nolla_Games_Noita/save00";
      # コピー先/元を省略した場合のデフォルトパス
      defaultBackupDir = "\${XDG_DOCUMENTS_DIR:-$HOME/Files/Documents}/noita-save00";
    in [
      # Noitaのセーブデータ(save00)はクラウド同期と相性が悪いため手動バックアップ/リストアする
      (pkgs.writeShellScriptBin "noita-backup-save" ''
        set -euo pipefail

        src="${noitaSaveDir}"
        dest="''${1:-${defaultBackupDir}}"

        if [[ ! -d "$src" ]]; then
          echo "Noitaのセーブディレクトリが見つかりません: $src" >&2
          exit 1
        fi

        mkdir -p "$(dirname "$dest")"
        rm -rf "$dest"
        cp -r "$src" "$dest"
        echo "バックアップしました: $dest"
      '')

      (pkgs.writeShellScriptBin "noita-restore-save" ''
        set -euo pipefail

        dest="${noitaSaveDir}"
        src="''${1:-${defaultBackupDir}}"

        if [[ ! -d "$src" ]]; then
          echo "復元元のバックアップが見つかりません: $src" >&2
          exit 1
        fi

        echo "現在のセーブデータ ($dest) を $src の内容で上書きします。"
        read -rp "続行しますか? [y/N] " reply
        if [[ ! "$reply" =~ ^[yY]$ ]]; then
          echo "中止しました。"
          exit 1
        fi

        mkdir -p "$(dirname "$dest")"
        rm -rf "$dest"
        cp -r "$src" "$dest"
        echo "復元しました: $dest"
      '')
    ];
  };
}
