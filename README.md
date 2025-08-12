# nix-config

Nix OSの設定ファイル

## セットアップ

### WSL2だけ

- [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) に従う
    - https://nix-community.github.io/NixOS-WSL/how-to/change-username.html
        - `hosts/plum/users` の名前と同じにしておく

### 共通

- nix-secret レポジトリ(private)でSSH鍵登録を済ませておく
    - https://github.com/pachicobue/nix-secret/blob/main/README.md
- `nix develop --experimental-features "nix-commands flakes"`

## インストール・更新

### coconut

- (nix-secret更新後のみ) `nix flake update my-nix-secret`
- `switch coconut`

### plum

- (nix-secret更新後のみ) `nix flake update my-nix-secret`
- `switch plum`

## Credits

- [numtide/blueprint](https://github.com/numtide/blueprint)

## License

This project is licensed under the MIT License, see the [LICENSE](LICENSE) file for details.

