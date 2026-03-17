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

- [ ] denixをinputsに追加
  ```nix
  denix = {
    url = "github:yunfachi/denix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  ```
- [ ] outputsのnixosConfigurations / homeConfigurationsをdelib.configurationsに書き換え
  ```nix
  nixosConfigurations = denix.lib.configurations {
    moduleSystem = "nixos";
    homeManagerUser = "sho";
    paths = [ ./host ./module ./rice ];
    specialArgs = { inherit inputs; };
    extensions = [ denix.lib.extensions.args ];
  };
  ```
- [ ] 手動で書いていた4ホスト分のnixosConfigurationsエントリを削除
- [ ] `nix flake update` でlock更新
- [ ] `nix flake check` で構文エラーがないことを確認

---

## Phase 2: host/のdelib.host化

各ホストをdelib.hostで定義。既存の `host/[name]/` 配下のnixos.nix + home.nixをdefault.nixに統合。

- [ ] `host/coconut/default.nix` 作成 (delib.host, rice = "catppuccin-mocha")
  - [ ] nixos.nix + home.nix の内容を統合
  - [ ] hardware-configuration.nix / disk-config.nix は同ディレクトリに残す
  - [ ] home.stateVersion = "25.05" 設定
- [ ] `host/plum/default.nix` 作成 (WSL2: nixos-wslをnixosブロックでimport)
- [ ] `host/berry/default.nix` 作成
  - [ ] main-disk-config.nix / extra-disk-config.nix は同ディレクトリに残す
  - [ ] container.nix の扱いを決定
- [ ] `host/pi4/default.nix` 作成 (aarch64: system指定に注意)
  - [ ] container.nix の扱いを決定
- [ ] coconutのみで `nix build .#nixosConfigurations.coconut-catppuccin-mocha.config.system.build.toplevel` が通ることを確認

---

## Phase 3: moduleへのconstants追加

既存モジュールはstandardなNixOSモジュールのままauto-importで動く。ディレクトリ移動は不要。

- [ ] `module/config/constants.nix` を新規作成 (delib.module + readOnly)
  - username, email, GPG key, SSH keysなどの定数を集約
- [ ] flake.nixのpathsが `./module` を参照していることを確認
- [ ] 全ホストでビルドが通ることを確認

---

## Phase 4: rice/の作成

stylixのcatppuccin-mocha設定をriceとして分離。

- [ ] `rice/catppuccin-mocha/default.nix` 作成 (delib.rice)
  - [ ] `module/nixos/stylix.nix` の内容を移動
  - [ ] `module/home/stylix.nix` の内容を移動
  - [ ] base16-schemesのyamlファイルをrice/へコピー
- [ ] 元のstylix.nixモジュールを削除
- [ ] ビルド・テスト確認

---

## Phase 5: deploy-rsとagenixの対応

- [ ] `deploy.nix` のnixosConfigurations参照を更新
  - `self.nixosConfigurations.coconut` → `self.nixosConfigurations.coconut-catppuccin-mocha`
  - berry, pi4も同様
- [ ] `check.nix` の参照も同様に更新
- [ ] `script/switch.py` (存在する場合) のホスト名参照を更新
- [ ] agenixのsecrets.nixはSSHキー参照のみのため変更不要であることを確認
- [ ] deploy-rsでcoconutへのデプロイテスト

---

## Phase 6 (オプション): delib.moduleへの段階的リファクタ

以下のモジュールを優先的にdelib.moduleパターンへ変換する。必須ではない。

- [ ] `module/nixos/audio.nix`
- [ ] `module/nixos/bluetooth.nix`
- [ ] `module/nixos/tailscale.nix`
- [ ] `module/home/common/git.nix`
- [ ] `module/home/common/zsh.nix`
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

<!-- 作業中に気づいたことや問題点をここに記録 -->
