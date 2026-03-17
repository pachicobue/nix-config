# denix移行計画

## 概要

現在のNixOS設定をdenixライブラリを使った構造に移行する。

- **denix**: https://github.com/yunfachi/denix / https://denix.ynf.sh/
- **目的**: multi-hostをdelib.configurationsで自動管理、riceによるテーマ切り替え、モジュール記述の簡略化

## 構造対応表

| 現在 | 移行後 |
|------|--------|
| `host/[name]/nixos.nix` + `home.nix` | `host/[name]/default.nix` (delib.host) |
| `module/nixos/` + `module/home/` | `module/` (auto-import、ディレクトリ名変更なし) |
| module/nixos/stylix.nix + module/home/stylix.nix | `rice/catppuccin-mocha/default.nix` (delib.rice) |
| 手動 nixosConfigurations × 4ホスト | delib.configurations で自動生成 |

---

## Phase 1: flake.nixの変更

- [x] denixをinputsに追加 (home-manager.followsも追加)
- [x] outputsのnixosConfigurationsをdelib.configurationsに書き換え
  - `paths = [ ./host ./module/config ./rice ]`, `extensions = [ base ]`, `specialArgs = { inherit inputs commonConfig; }`
  - 計画と一部異なる点: `./module` 全体ではなく `./module/config` のみ追加 (auto-import問題回避)
- [x] 手動で書いていた4ホスト分のnixosConfigurationsエントリを削除 (nixos-configuration.nixごと削除)
- [x] `nix flake update` でlock更新 (denixのみ)
- [x] `nix flake check` で構文エラーがないことを確認

---

## Phase 2: host/のdelib.host化

各ホストをdelib.hostで定義。既存の `host/[name]/` 配下のnixos.nix + home.nixをdefault.nixに統合。

- [x] `host/coconut/default.nix` 作成 (delib.host, rice = "catppuccin-mocha")
  - [x] nixos.nix + home.nix の内容を統合
  - [x] hardware-configuration.nix / disk-config.nix を hardware/coconut/ に移動
  - [x] home.stateVersion = "25.05" 設定
- [x] `host/plum/default.nix` 作成 (WSL2: nixos-wslをnixosブロックでimport)
- [x] `host/berry/default.nix` 作成
  - [x] main-disk-config.nix / extra-disk-config.nix を hardware/berry/ に移動
  - [x] container.nix の内容をdefault.nixにインライン化
- [x] `host/pi4/default.nix` 作成 (aarch64: system = "aarch64-linux"指定)
  - [x] container.nix の内容をdefault.nixにインライン化
- [x] 全ホストで `nix flake check` が通ることを確認
  - 注: `nixosConfigurations.coconut` キーでもrice適用済み (host.rice = "catppuccin-mocha"のため)

---

## Phase 3: moduleへのconstants追加

既存モジュールはstandardなNixOSモジュールのままauto-importで動く。ディレクトリ移動は不要。

- [x] `module/config/constants.nix` を新規作成 (delib.module + readOnly)
  - username, email, GPG key, SSH keysなどの定数を集約
  - specialArgs.commonConfigを参照してオプションのdefaultに設定
- [x] flake.nixのpathsに `./module/config` を追加
- [x] 全ホストでビルドが通ることを確認

---

## Phase 4: rice/の作成

stylixのcatppuccin-mocha設定をriceとして分離。

- [x] `rice/catppuccin-mocha/default.nix` 作成 (delib.rice)
  - [x] `module/nixos/stylix.nix` の内容を移動
  - [x] `module/home/stylix.nix` の内容を移動
  - nixos block内でhostConfig.desktop != "none"の場合のみstylix有効化
  - coconut/default.nixにrice = "catppuccin-mocha"を追加
- [x] 元のstylix.nixモジュールを削除
- [x] flake.nixのpathsに./riceを追加
- [x] ビルド・テスト確認

---

## Phase 5: deploy-rsとagenixの対応

- [x] `deploy.nix` のnixosConfigurations参照を確認
  - deploy対象はdesktop == "none"のberry/pi4のみ
  - `nixosConfigurations.berry`, `nixosConfigurations.pi4` キーは引き続き存在
  - 変更不要
- [x] `check.nix` の参照を確認 — deploy.nixを間接参照するのみ、変更不要
- [x] `script/switch.py` — 存在しないことを確認
- [x] agenixのsecrets.nixはSSHキー参照のみのため変更不要であることを確認
- [ ] deploy-rsでのデプロイテスト (実機確認)

---

## Phase 6 (オプション): delib.moduleへの段階的リファクタ

以下のモジュールを優先的にdelib.moduleパターンへ変換する。必須ではない。

- [x] `module/nixos/audio.nix` — delib.module (options.audio.enable, nixos.ifEnabled)
- [x] `module/nixos/bluetooth.nix` — delib.module (options.bluetooth.enable, nixos.ifEnabled)
- [x] `module/nixos/tailscale.nix` — delib.module (options.tailscale.enable, nixos.ifEnabled)
  - 注: delib.moduleのoptionsはmyconfig.プレフィックス不要 (module.nixが自動付与)
  - coconut/berry/pi4のhostファイルに `myconfig.<name>.enable = true` を追加
- [x] `module/home/common/git.nix` — commonConfig.* → osConfig.myconfig.constants.* に置換 (delib.module化は非推奨: home-managerモジュールのため)
- [x] `module/home/common/zsh.nix` — dotDirを相対パスに修正 (`.config/zsh`)
- [ ] その他モジュールを順次変換

delib.moduleパターン例:
```nix
{ delib, ... }:
delib.module {
  name = "audio";
  options.audio = with delib; {
    enable = boolOption false;
  };
  nixos.ifEnabled = { ... }: {
    services.pipewire.enable = true;
    # ...
  };
}
```

---

## 注意事項

- **nixosConfigurationsのキー形式が変わる**: `coconut` → `coconut-catppuccin-mocha`
  - `nixos-rebuild --flake .#coconut-catppuccin-mocha` となる
  - deploy.nix, check.nix, スクリプト類を要更新
- **plum (WSL2)**: nixos-wslモジュールをdelib.hostのnixosブロックでimportする
- **pi4 (aarch64)**: specialArgsまたはdelib.hostでsystem = "aarch64-linux"を指定する
- **host/内の旧ファイル**: nixos.nix / home.nix はdefault.nix移行後に削除する
- 各Phaseの完了後に `nix flake check` を実行すること

---

## 進捗メモ

### Phase 1

- outputsのdelib.configurations書き換えはPhase 2 (host/のdelib.host化) と同時に行う
  - host/[name]/default.nix が存在しないと delib.configurations がビルドできないため
- flake.nixの `common` attrset (userName, email, gpg, sshKeys, network等) は
  Phase 3で `module/config/constants.nix` に移行する予定
- 現在のspecialArgsは `hostConfig`, `commonConfig`, `allHostConfig` を渡しているが、
  denix移行後は `myconfig.*` オプションに置き換わる → 全モジュールの参照を更新する必要あり
