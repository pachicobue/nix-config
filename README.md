# nixos-dotfiles

Nix OS configurations

## Installation

### NixOS Desktop (native)

1. `nix develop --extra-experimental-features nix-commands --extra-experimental-features flakes`
2. `switch-nixos desktop`
3. `switch-home desktop`
4. (optional) `direnv allow`

### NixOS on WSL2

0. Follow [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)'s insturction.
    - https://nix-community.github.io/NixOS-WSL/#quick-start
    - https://nix-community.github.io/NixOS-WSL/how-to/change-username.html
1. `nix develop --extra-experimental-features nix-commands --extra-experimental-features flakes`
2. `switch-nixos wsl --impure`
3. `switch-home wsl`
4. (optional) `direnv allow`

## Credits

- [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs/tree/main/standard)

## License

This project is licensed under the MIT License, see the [LICENSE](LICENSE) file for details.

