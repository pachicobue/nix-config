# nix-config

Nix OSの設定ファイル

## 準備

### Native

- [NixOS_Installation_Guide)](https://nixos.wiki/wiki/NixOS_Installation_Guide) に従う

### WSL2

- [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) にしたがってWSL環境立ち上げ
    - https://nix-community.github.io/NixOS-WSL/#quick-start
    - https://nix-community.github.io/NixOS-WSL/how-to/change-username.html
        - `hosts/wsl/users` の名前と同じにしておく

## インストール手順

- `nix develop --extra-experimental-features nix-commands --extra-experimental-features flakes`
- githubにssh鍵を登録（flakeでプライベートレポジトリをpullするため）
    - `ssh-keygen`
    - `gh ssh-key add ~/.ssh/id_ed25519.pub`

### NixOS Desktop

- （nix-secret更新後のみ）`nix flake update my-nix-secret`
- `switch desktop`

### NixOS on WSL2

- （nix-secret更新後のみ）`nix flake update my-nix-secret`
- `switch wsl`

## 設計

### ディレクトリ構成

```
nix-config/
├── flake.nix                    # メインエントリポイント
├── lib/
│   └── collectFromDirectory.nix # 共通の設定収集関数
├── hosts/
│   ├── desktop/
│   │   ├── default.nix          # ホスト固有の設定収集
│   │   ├── configuration.nix    # システム設定
│   │   ├── hardware-configuration.nix
│   │   └── users/
│   │       └── sho.nix          # ユーザ設定
│   ├── wsl/
│   │   ├── default.nix
│   │   ├── configuration.nix
│   │   └── users/
│   │       └── sho.nix
│   └── vm/
│       ├── default.nix
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── users/
│           └── sho.nix
└── modules/
    ├── nixos/                   # システムレベルモジュール
    │   ├── common.nix
    │   ├── fcitx.nix
    │   └── ...
    └── home/                    # Home Managerモジュール
        ├── common.nix
        ├── helix.nix
        └── ...
```

### アーキテクチャ

#### 1. モジュール自動収集
- `modules/nixos/`と`modules/home/`以下のファイルから`packagesFromDirectoryRecursive`を使用して自動的にattrset(`nixosModules`, `homeModules`)を作成
- 各モジュールは必要な引数を受け取る形式

#### 2. ホスト自動走査
- `hosts/`ディレクトリを自動走査して全ホストを検出
- 各ホストの`default.nix`がそのホスト固有の設定収集を担当

#### 3. 設定収集の責務分離
- **`lib/collectFromDirectory.nix`**: 共通の収集関数を提供
  - `collectUsers`: usersディレクトリからユーザ一覧を取得
  - `importUserConfigs`: ユーザ設定をimportして適切な引数を渡す
  - `importHostConfig`: ホスト設定をimportして適切な引数を渡す
  - `hasHardwareConfig`: hardware-configuration.nixの存在確認

- **`hosts/${hostname}/default.nix`**: ホスト固有の設定収集
  - 共通ライブラリを使用してusers/以下を自動収集
  - configuration.nixとusers/*.nixをimport
  - nixosSystem用の設定オブジェクトを返す

#### 4. 引数体系
- **`hosts/${hostname}/configuration.nix`**: `{ system, nixosModules, homeModules, hostname }`
- **`hosts/${hostname}/users/${username}.nix`**: `{ system, nixosModules, homeModules, hostname, username }`
- **`hosts/${hostname}/default.nix`**: `{ system, nixosModules, homeModules, hostname, inputs, collectLib }`

#### 5. シンプルなflake.nix
- モジュール収集とホスト自動走査のみを担当
- 複雑なロジックは各ホストのdefault.nixに委譲
- 保守性と拡張性を重視した設計

## Credits

- [numtide/blueprint](https://github.com/numtide/blueprint)

## License

This project is licensed under the MIT License, see the [LICENSE](LICENSE) file for details.

