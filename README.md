# nix-config

Nix OSの設定ファイル

## セットアップ

### WSL2だけ

- [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) に従う
    - [ユーザー名変更しておく](https://nix-community.github.io/NixOS-WSL/how-to/change-username.html)

### 共通

flakes が未有効の素の NixOS から、`nixos-rebuild` で直接適用する。

```
nix-shell -p git --run "git clone https://github.com/pachicobue/nix-config ~/nix-config"
cd ~/nix-config
sudo nixos-rebuild switch --flake .#<hostname> --option experimental-features "nix-command flakes"
```

初回適用後は flakes / direnv / devenv が有効になり、リポジトリに入ると `.envrc` 経由で devShell (`switch` 等) が自動で読み込まれる (初回のみ `direnv allow` が必要)。

## インストール・更新


```
switch <hostname>                      # ローカルへ適用
switch <hostname> --remote             # SSH経由でリモートへ適用 (root@<hostname>)
switch <hostname> --remote user@host   # 任意のSSHターゲットへ適用
```

## Credits

- [yunfachi/denix](https://github.com/yunfachi/denix)
- [yunfachi/nix-config](https://github.com/yunfachi/nix-config)

## License

This project is licensed under the MIT License, see the [LICENSE](LICENSE) file for details.

