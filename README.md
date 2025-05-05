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

## Credits

- [numtide/blueprint](https://github.com/numtide/blueprint)

## License

This project is licensed under the MIT License, see the [LICENSE](LICENSE) file for details.

