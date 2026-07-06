# ワークフロー

- コードを変更したら `jj status` でファイルをaddした後、`nix flake check` で検証してください
- `switch` コマンドは管理者権限が必要なため、ユーザーが手動で実行します

## コマンド

```bash
nix develop           # devShell に入る (switch スクリプト等を含む)
nix flake check      # 変更を検証
nix fmt              # コード整形 (alejandra / taplo / shfmt)
# 以下は管理者権限が必要 — ユーザーが手動で実行
switch <hostname>                      # ローカルへ適用
switch <hostname> --remote             # SSH経由でリモートへ適用 (root@<hostname>)
switch <hostname> --remote user@host  # 任意のSSHターゲットへ適用
```

## アーキテクチャ

[Denix](https://github.com/yunfachi/denix) フレームワークを使用。

```
hosts/         # 各マシンの定義 (berry, coconut, pi4, plum)
modules/
  config/      # 汎用設定モジュール (定数・コマンド・ブート等)
  programs/    # プログラム別の home-manager 設定
  services/    # NixOS サービス設定
  toplevel/    # ホストタイプ別の共通設定
rices/         # テーマ設定 (catppuccin-mocha 等)
secrets/       # agenix-rekey で暗号化されたシークレット
scripts/       # Python製のラッパースクリプト
```

ホストタイプ: `desktop` / `laptop` / `server` / `virtual`
ホスト機能: `cli` / `gui` / `wayland` / `x11` / `bluetooth` / `usb` / `wsl2` / `nvidia`

## パターン

新しいモジュールの定義:
```nix
# modules/programs/foo.nix
delib.module {
  name = "programs.foo";
  options = delib.singleEnableOption false;
  home.ifEnabled = { ... };   # home-manager 設定
  nixos.ifEnabled = { ... };  # NixOS 設定
}
```

新しいホストの定義:
```nix
# hosts/<name>/default.nix
delib.host {
  name = "<hostname>";
  type = "desktop";       # ホストタイプ
  features = ["wayland"]; # 追加機能 (タイプのデフォルトに追加)
  myconfig = { ... };     # myconfig.* オプション空間で設定を渡す
}
```

## Gotcha

- `myconfig.*` は Denix の設定オプション空間 (NixOS の `config.*` とは別)
- シークレットは `agenix-rekey` で管理 — `secrets/*.age` を編集後は `agenix rekey` が必要
- `delib.singleEnableOption` は `myconfig.programs.foo.enable` を生成する
