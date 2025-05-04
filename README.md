# nix-config

Nix OSの設定ファイル

## レポジトリを

## Install手順

### NixOS Desktop (native)

1. `nix develop --extra-experimental-features nix-commands --extra-experimental-features flakes`
2. `switch desktop`
3. (optional) `direnv allow`

### NixOS on WSL2

0. Follow [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)'s insturction.
    - https://nix-community.github.io/NixOS-WSL/#quick-start
    - https://nix-community.github.io/NixOS-WSL/how-to/change-username.html
1. `nix develop --extra-experimental-features nix-commands --extra-experimental-features flakes`
2. `switch wsl`
3. (optional) `direnv allow`

## Credits

- [numtide/blueprint](https://github.com/numtide/blueprint)

## License

This project is licensed under the MIT License, see the [LICENSE](LICENSE) file for details.

