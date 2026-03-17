# denix移行 Phase 7: 完全なdelib.host形式への移行

yunfachi/nix-config を参考に、手動 imports と hostConfig workaround を排除し、
真の yunfachi スタイルの delib.host 形式に移行する。

## 目標とする形式（yunfachiスタイル）

```nix
{ delib, ... }:
delib.host {
  name = "hostname";
  system = "x86_64-linux";
  rice = "catppuccin-mocha";

  myconfig = { ... }: {
    host.desktop = "wayland";
    host.network.useDhcp = true;
    host.network.iface.name = "eno1";
    host.network.iface.mac = "08:bf:b8:a5:74:f7";
    host.network.iface.enableWol = true;
    audio.enable = true;
    bluetooth.enable = true;
    tailscale.enable = true;
    # ... etc
  };

  nixos = { ... }: {
    system.stateVersion = "25.05";
    networking.hostName = "coconut";
    nixpkgs.config.allowUnfree = true;
    boot = { ... };
    # host-specific config only, no imports/hostConfig
  };

  home = { ... }: {
    home.stateVersion = "25.05";
    programs.helix.defaultEditor = true;
    # host-specific home config only
  };
}
```

## 現状との差分

1. **手動 `imports = [...]`** → pathsでの自動ディスカバリに置き換え
2. **`hostConfig` workaround** → `myconfig.host.*` オプションに置き換え
3. **`myconfig.*` の位置** → nixosブロック内から `myconfig = {...}:` ブロックに移動
4. **`_module.args.hostConfig`** → 削除
5. **`home-manager.extraSpecialArgs`** → 削除

---

## Step 1: module/config/host.nix の作成 [ ]

```nix
{ delib, ... }:
delib.module {
  name = "host";
  options.host = with delib; {
    desktop = strOption "none";
    network = submoduleOption {
      options = {
        useDhcp = boolOption true;
        iface = submoduleOption {
          options = {
            name = strOption "";
            mac = strOption "";
            address = strOption "";
            enableWol = boolOption false;
          };
        };
      };
    };
  };
}
```

---

## Step 2: nixos モジュールの delib.module 変換 [ ]

### hostConfig を使うモジュール（myconfig.host.* に置き換え）

#### module/nixos/common.nix → delib.module に変換 [ ]

現在: `hostConfig.desktop` 参照
変換後:
```nix
{ delib, pkgs, lib, ... }:
delib.module {
  name = "common";
  nixos.always = { myconfig, ... }: {
    imports = [
      ./common/user.nix
      ./common/sudo.nix
      ./common/dbus.nix
      ./common/nix.nix
      ./common/network.nix
      ./common/kmscon.nix
      ./common/font.nix
      ./common/zsh.nix
      ./common/git.nix
      ./common/direnv.nix
      ./common/agenix.nix
    ];
    home-manager.useGlobalPkgs = true;
    time.timeZone = "Asia/Tokyo";
    i18n.defaultLocale = "ja_JP.UTF-8";
    environment = {
      shellAliases = { e = "$EDITOR"; rm = "rm -i"; cp = "cp -i"; };
      sessionVariables = lib.mkIf (myconfig.host.desktop == "wayland") {
        NIXOS_OZONE_WL = "1";
      };
      systemPackages = with pkgs;
        [ tealdeer fastfetch procs ripgrep fd dust bottom sd tailspin skim ]
        ++ lib.optionals (myconfig.host.desktop != "none") [ wl-clipboard waypipe ];
      pathsToLink = lib.mkIf (myconfig.host.desktop != "none") [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ];
    };
  };
}
```

**注意**: common.nixはsub-modulesをimportsで読み込む形を維持（aggregate as delib.module）。
module/nixos をpathsに追加すると common/user.nix等もauto-discoverされるが、
NixOSモジュールシステムが重複を処理するため問題なし。
ただし common/以下のファイルも全て delib.module に変換が必要。

#### module/nixos/common/network.nix → delib.module に変換 [ ]

```nix
{ delib, lib, pkgs, ... }:
delib.module {
  name = "nixos.network";
  nixos.always = { myconfig, config, ... }: let
    iface = myconfig.host.network.iface;
  in {
    networking = {
      useDHCP = myconfig.host.network.useDhcp;
      interfaces = lib.mkIf (iface.address != "") {
        ${iface.name} = {
          ipv4.addresses = [{ address = iface.address; prefixLength = 24; }];
        };
      };
      defaultGateway = lib.mkIf (!myconfig.host.network.useDhcp) myconfig.constants.network.gateway;
      firewall.enable = true;
    };
    programs.tcpdump.enable = true;
    environment.systemPackages = with pkgs; [ tcpdump dnslookup ];
  };
}
```

#### module/nixos/wakeonlan.nix → delib.module に変換 [ ]

```nix
{ delib, lib, pkgs, ... }:
delib.module {
  name = "wakeonlan";
  options.wakeonlan.enable = delib.boolOption false;
  nixos.ifEnabled = { myconfig, ... }: let
    iface = myconfig.host.network.iface;
    wolHosts = myconfig.constants.wolHosts;
    wol-command = pkgs.writeShellScriptBin "wol" ''...'';
  in {
    networking.interfaces = lib.mkIf iface.enableWol {
      ${iface.name}.wakeOnLan = { enable = true; policy = ["magic"]; };
    };
    environment.systemPackages = [ pkgs.ethtool pkgs.wakeonlan wol-command ];
  };
}
```

#### module/nixos/openssh.nix → delib.module に変換 [ ]

```nix
{ delib, lib, ... }:
delib.module {
  name = "openssh";
  options.openssh.enable = delib.boolOption false;
  nixos.ifEnabled = { myconfig, ... }: {
    services.openssh = {
      enable = true;
      settings = {
        X11Forwarding = lib.mkIf (myconfig.host.desktop == "x") true;
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
    };
    environment.enableAllTerminfo = true;
  };
}
```

#### module/nixos/gaming.nix → delib.module に変換 [ ]

```nix
{ delib, pkgs, lib, ... }:
delib.module {
  name = "gaming";
  options.gaming.enable = delib.boolOption false;
  nixos.ifEnabled = { myconfig, ... }: {
    programs.steam = {
      enable = true;
      protontricks.enable = true;
      gamescopeSession.enable = true;
      extest.enable = lib.mkIf (myconfig.host.desktop == "x") true;
      fontPackages = with pkgs; [ noto-fonts-cjk-sans ];
    };
    programs.gamemode.enable = true;
  };
}
```

#### module/nixos/fcitx.nix → delib.module に変換 [ ]

```nix
{ delib, pkgs, ... }:
delib.module {
  name = "fcitx";
  options.fcitx.enable = delib.boolOption false;
  nixos.ifEnabled = { myconfig, ... }: {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = myconfig.host.desktop == "wayland";
        addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
        # ... settings unchanged
      };
    };
  };
}
```

#### module/nixos/greetd/regreet.nix → delib.module に変換 [ ]

```nix
{ delib, pkgs, lib, ... }:
delib.module {
  name = "regreet";
  options.regreet.enable = delib.boolOption false;
  nixos.ifEnabled = { myconfig, ... }:
    lib.mkIf (myconfig.host.desktop == "wayland") {
      programs.regreet.enable = true;
      services.greetd = { ... };
    };
}
```

#### module/nixos/greetd/tuigreet.nix → delib.module に変換 [ ]

```nix
{ delib, pkgs, lib, ... }:
delib.module {
  name = "tuigreet";
  options.tuigreet.enable = delib.boolOption false;
  nixos.ifEnabled = { myconfig, ... }:
    lib.mkIf (myconfig.host.desktop != "none") {
      services.greetd = { ... };
    };
}
```

#### module/nixos/wm/niri.nix → delib.module に変換 [ ]

nixosとhomeで同じ enable オプションを共有。
nixos側でオプションを定義し、home側は lib.mkIf で参照。

```nix
{ delib, inputs, pkgs, lib, ... }:
delib.module {
  name = "wm.niri";
  options."wm.niri".enable = delib.boolOption false;
  nixos.ifEnabled = { myconfig, ... }:
    lib.mkIf (myconfig.host.desktop == "wayland") {
      nixpkgs.overlays = [inputs.niri-flake.overlays.niri];
      programs.niri = { enable = true; package = pkgs.niri; };
      security.soteria.enable = true;
      services.displayManager.sessionPackages = [pkgs.niri];
    };
}
```

#### module/nixos/wm/hyprland.nix → delib.module に変換 [ ]

```nix
{ delib, lib, ... }:
delib.module {
  name = "wm.hyprland";
  options."wm.hyprland".enable = delib.boolOption false;
  nixos.ifEnabled = { myconfig, ... }:
    lib.mkIf (myconfig.host.desktop == "wayland") {
      programs.hyprland = { enable = true; withUWSM = true; };
      services.displayManager.sessionPackages = [ ... ];
    };
}
```

### hostConfig を使わないモジュール（wrap するだけ）

#### module/nixos/common/kmscon.nix [ ]
```nix
{ delib, ... }:
delib.module {
  name = "nixos.kmscon";
  nixos.always.services.kmscon.enable = true;
}
```

#### module/nixos/common/sudo.nix [ ]
```nix
{ delib, ... }:
delib.module {
  name = "nixos.sudo";
  nixos.always.security = { sudo.enable = false; sudo-rs.enable = true; };
}
```

#### module/nixos/common/neovim.nix [ ]
```nix
{ delib, ... }:
delib.module {
  name = "nixos.neovim";
  nixos.always.programs.neovim = { enable = true; defaultEditor = true; };
}
```

#### module/nixos/common/direnv.nix [ ]
```nix
{ delib, ... }:
delib.module {
  name = "nixos.direnv";
  nixos.always.programs.direnv = {
    enable = true; nix-direnv.enable = true; enableZshIntegration = true;
  };
}
```

#### module/nixos/common/zsh.nix [ ]
```nix
{ delib, ... }:
delib.module {
  name = "nixos.zsh";
  nixos.always.programs.zsh = { enable = true; enableCompletion = true; };
}
```

#### module/nixos/common/git.nix [ ]
```nix
{ delib, pkgs, ... }:
delib.module {
  name = "nixos.git";
  nixos.always.environment.systemPackages = [ pkgs.git pkgs.gh ];
}
```

#### module/nixos/common/dbus.nix [ ]
```nix
{ delib, ... }:
delib.module {
  name = "nixos.dbus";
  nixos.always.services.dbus.implementation = "broker";
}
```

#### module/nixos/common/font.nix [ ]
```nix
{ delib, pkgs, ... }:
delib.module {
  name = "nixos.font";
  nixos.always.fonts = { ... };  # 現在のまま
}
```

#### module/nixos/common/nix.nix [ ]
```nix
{ delib, ... }:
delib.module {
  name = "nixos.nix";
  nixos.always.nix = { ... };  # 現在のまま
}
```

#### module/nixos/common/agenix.nix [ ]
```nix
{ delib, inputs, ... }:
delib.module {
  name = "nixos.agenix";
  nixos.always = {
    imports = [ inputs.agenix.nixosModules.default ];
    age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };
}
```

#### module/nixos/common/user.nix [ ]
```nix
{ delib, pkgs, ... }:
delib.module {
  name = "nixos.user";
  nixos.always = { myconfig, ... }: {
    users = { ... };  # myconfig.constants.* を使用
    programs.zsh.enable = true;
  };
}
```

#### module/nixos/keyboard.nix [ ]
```nix
{ delib, ... }:
delib.module {
  name = "keyboard";
  options.keyboard.enable = delib.boolOption false;
  nixos.ifEnabled = { ... };
}
```

#### module/nixos/yubikey.nix [ ]
```nix
{ delib, pkgs, ... }:
delib.module {
  name = "yubikey";
  options.yubikey.enable = delib.boolOption false;
  nixos.ifEnabled.services.pcscd.enable = true;
  # ...
}
```

#### module/nixos/usb.nix [ ]
```nix
{ delib, pkgs, ... }:
delib.module {
  name = "usb";
  options.usb.enable = delib.boolOption false;
  nixos.ifEnabled = { ... };
}
```

#### module/nixos/nvidia.nix [ ]
```nix
{ delib, ... }:
delib.module {
  name = "nvidia";
  options.nvidia.enable = delib.boolOption false;
  nixos.ifEnabled = { ... };
}
```

#### module/nixos/ddc.nix [ ]
```nix
{ delib, pkgs, ... }:
delib.module {
  name = "ddc";
  options.ddc.enable = delib.boolOption false;
  nixos.ifEnabled = { ... };
}
```

---

## Step 3: home モジュールの delib.module 変換 [ ]

### home/common/* (always-on)

#### module/home/common/xdg.nix [ ]
```nix
{ delib, ... }:
delib.module {
  name = "home.xdg";
  home.always = { config, ... }: { xdg.userDirs = { ... }; };
}
```

#### module/home/common/atuin.nix, carapace.nix, starship.nix, lsd.nix, ssh.nix, zoxide.nix, bat.nix, pueue.nix, fastfetch.nix [ ]
それぞれ `home.always = { ... };` に変換

#### module/home/common/zsh.nix [ ]
```nix
home.always = { config, ... }: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";  # 相対パスに修正（絶対パスから変更）
    # ...
  };
};
```

#### module/home/common/git.nix [ ]
```nix
home.always = { myconfig, osConfig, ... }: {
  programs.git = {
    signing.key = osConfig.myconfig.constants.gpg;
    # ...
  };
};
```
※ osConfig は home-manager の NixOS config アクセス

#### module/home/common/gnupg.nix [ ]
always-on に変換

#### module/home/common/jj.nix [ ]
```nix
home.always = { myconfig, osConfig, pkgs, ... }: { ... };
```

### home app modules (optional)

#### module/home/alacritty.nix [ ]
```nix
{ delib, ... }:
delib.module {
  name = "alacritty";
  options.alacritty.enable = delib.boolOption false;
  home.ifEnabled = { ... };
}
```

#### module/home/helix.nix [ ]
```nix
{ delib, inputs, pkgs, ... }:
delib.module {
  name = "helix";
  options.helix.enable = delib.boolOption false;
  home.ifEnabled = { ... };
}
```

#### module/home/firefox.nix [ ]
```nix
{ delib, pkgs, lib, ... }:
delib.module {
  name = "firefox";
  options.firefox.enable = delib.boolOption false;
  home.ifEnabled = { ... };
}
```

#### module/home/discord.nix [ ]
```nix
{ delib, pkgs, ... }:
delib.module {
  name = "discord";
  options.discord.enable = delib.boolOption false;
  home.ifEnabled.home.packages = [ pkgs.discord ];
}
```

#### module/home/claude-code.nix [ ]
```nix
{ delib, pkgs, ... }:
delib.module {
  name = "claude-code";
  options."claude-code".enable = delib.boolOption false;
  home.ifEnabled = { ... };
}
```

#### module/home/zathura.nix, fuzzel.nix [ ]
同様に enable フラグ付きに変換

#### module/home/mako.nix [ ]

現在: `hostConfig.desktop == "wayland"` 参照
変換後:
```nix
{ delib, lib, ... }:
delib.module {
  name = "mako";
  options.mako.enable = delib.boolOption false;
  home.ifEnabled = { myconfig, ... }:
    lib.mkIf (myconfig.host.desktop == "wayland") {
      services.mako = { enable = true; settings.default-timeout = 5000; };
    };
}
```

### home wm modules

#### module/home/wm/niri.nix [ ]

nixos/wm/niri.nix で定義された `options."wm.niri".enable` を参照:

```nix
{ delib, inputs, pkgs, lib, config, ... }:
delib.module {
  name = "home.wm.niri";
  # オプション定義なし（nixos/wm/niri.nixと共有）
  home.always = { myconfig, ... }:
    lib.mkIf (myconfig."wm.niri".enable or false) {
      imports = [inputs.niri-flake.homeModules.niri];
      # alacritty, jq, noctalia-shell のimportsは削除（auto-discover経由）
      programs.niri = { enable = true; ... };
    };
}
```

#### module/home/wm/hyprland.nix [ ]

```nix
{ delib, pkgs, lib, ... }:
delib.module {
  name = "home.wm.hyprland";
  home.always = { myconfig, ... }:
    lib.mkIf (myconfig."wm.hyprland".enable or false) {
      imports = [
        ./hyprland/config.nix    # これらは標準HMモジュールのまま残す
        ./hyprland/keybind.nix   # （pathsに含まれないためauto-discoverされない）
      ];
      wayland.windowManager.hyprland = { ... };
    };
}
```

**注**: `home/hyprland/` 以下のファイルは standard HM module のまま。
`module/home` をpathsに追加するとこれらもdiscoverされるが、
standard HM moduleとして処理されるため問題ないはず。
もし問題が出れば hyprland/ 配下を delib.module に変換する。

---

## Step 4: module/nixos/common.nix の扱い [ ]

common.nixはsub-modulesをimportsで束ねるaggregate。
delib.module化後も `./common/` 以下のファイルはpathsでauto-discoverされる。
重複import はNixOSモジュールシステムが処理するため問題なし。

**選択肢A**: common.nixをdelib.module化し残す（sub-modulesも別途auto-discover）
**選択肢B**: common.nixを削除し、各sub-moduleがauto-discoverで適用される形に

→ **選択肢Aを採用**: sub-modulesを `nixos.always` の imports に残す。
→ ただし全sub-moduleを delib.module 化すれば、common.nixは不要になるため**最終的に削除**。

## Step 5: flake.nix の更新 [ ]

```nix
paths = [
  ./host
  ./module/config
  ./module/nixos
  ./module/home
  ./rice
];
```

---

## Step 6: host ファイルの更新 [ ]

### coconut/default.nix

```nix
{ delib, inputs, ... }:
delib.host {
  name = "coconut";
  system = "x86_64-linux";
  rice = "catppuccin-mocha";

  myconfig = { ... }: {
    host.desktop = "wayland";
    host.network.useDhcp = true;
    host.network.iface = {
      name = "eno1";
      mac = "08:bf:b8:a5:74:f7";
      enableWol = true;
    };
    audio.enable = true;
    bluetooth.enable = true;
    tailscale.enable = true;
    openssh.enable = true;
    ddc.enable = true;
    fcitx.enable = true;
    nvidia.enable = true;
    gaming.enable = true;
    wakeonlan.enable = true;
    usb.enable = true;
    yubikey.enable = true;
    regreet.enable = true;
    "wm.niri".enable = true;
    alacritty.enable = true;
    helix.enable = true;
    firefox.enable = true;
    discord.enable = true;
    "claude-code".enable = true;
    mako.enable = true;
    fuzzel.enable = true;
    zathura.enable = true;
  };

  nixos = { ... }: {
    system.stateVersion = "25.05";
    networking.hostName = "coconut";
    nixpkgs.config.allowUnfree = true;
    boot = { ... };
    security.polkit.extraConfig = ''...'';
  };

  home = { ... }: {
    home.stateVersion = "25.05";
    programs.helix.defaultEditor = true;
  };
}
```

### berry/default.nix [ ]

```nix
myconfig = { ... }: {
  host.desktop = "none";
  host.network.useDhcp = true;
  host.network.iface = {
    name = "enp1s0";
    mac = "68:1d:ef:37:e8:ab";
    enableWol = true;
  };
  tailscale.enable = true;
  deploy.enable = true;
  openssh.enable = true;
  wakeonlan.enable = true;
  helix.enable = true;
};
```

### pi4/default.nix [ ]

```nix
myconfig = { ... }: {
  host.desktop = "none";
  host.network.useDhcp = false;
  host.network.iface = {
    name = "eth0";
    address = "192.168.10.181";
    mac = "2c:cf:67:1a:1c:61";
  };
  tailscale.enable = true;
  deploy.enable = true;
  openssh.enable = true;
  wakeonlan.enable = true;
};
```

また、containerの `specialArgs` から `hostConfig` を削除。
`system.stateVersion` をcontainerに直接書く:
```nix
containers.adguardhome.config = { ... }: {
  system.stateVersion = "25.05";
  # hostConfig参照を削除
};
```

### plum/default.nix [ ]

```nix
myconfig = { ... }: {
  host.desktop = "wayland";
  host.network.useDhcp = true;
  usb.enable = true;
  yubikey.enable = true;
  "claude-code".enable = true;
  helix.enable = true;
};
```

---

## 注意事項

### common.nixのauto-import問題

`module/nixos` をpathsに追加すると:
- `module/nixos/common.nix` (delib.module) → auto-discover
- `module/nixos/common/user.nix` (delib.module) → auto-discover

common.nixが `imports = [./common/user.nix ...]` を持つ場合、user.nixが2回ロードされる。
NixOSモジュールシステムはこれを正しく処理するが、念のため common.nixを削除して
各sub-moduleのみauto-discoverに任せる方が安全。

→ **最終決定**: common.nixとhome/common.nixは削除。
全sub-moduleをdelib.moduleにして個別にauto-discover。

### home-manager の specialArgs

現在のflake.nixでは `specialArgs = { inherit inputs; }` を設定済み。
denixのbase拡張がhome-managerにも同じspecialArgsを渡すため、
`home-manager.extraSpecialArgs` は不要。

### containers の hostConfig 参照

pi4のcontainer `adguardhome` が `specialArgs` で `hostConfig` を渡している。
`container/adguardhome.nix` の中身を確認し、hostConfig参照を削除/置換する。

---

## 進捗

- [ ] Step 1: module/config/host.nix 作成
- [ ] Step 2: nixos modules delib.module 変換
  - [ ] common.nix
  - [ ] common/network.nix
  - [ ] common/kmscon.nix
  - [ ] common/sudo.nix
  - [ ] common/neovim.nix
  - [ ] common/direnv.nix
  - [ ] common/zsh.nix
  - [ ] common/git.nix
  - [ ] common/dbus.nix
  - [ ] common/font.nix
  - [ ] common/nix.nix
  - [ ] common/agenix.nix
  - [ ] common/user.nix
  - [ ] wakeonlan.nix
  - [ ] openssh.nix
  - [ ] gaming.nix
  - [ ] fcitx.nix
  - [ ] greetd/regreet.nix
  - [ ] greetd/tuigreet.nix
  - [ ] wm/niri.nix
  - [ ] wm/hyprland.nix
  - [ ] keyboard.nix
  - [ ] yubikey.nix
  - [ ] usb.nix
  - [ ] nvidia.nix
  - [ ] ddc.nix
- [ ] Step 3: home modules delib.module 変換
  - [ ] common/xdg.nix
  - [ ] common/atuin.nix
  - [ ] common/carapace.nix
  - [ ] common/starship.nix
  - [ ] common/git.nix
  - [ ] common/gnupg.nix
  - [ ] common/lsd.nix
  - [ ] common/ssh.nix
  - [ ] common/zsh.nix
  - [ ] common/zoxide.nix
  - [ ] common/jj.nix
  - [ ] common/bat.nix
  - [ ] common/pueue.nix
  - [ ] common/fastfetch.nix
  - [ ] alacritty.nix
  - [ ] helix.nix
  - [ ] firefox.nix
  - [ ] discord.nix
  - [ ] claude-code.nix
  - [ ] zathura.nix
  - [ ] fuzzel.nix
  - [ ] mako.nix
  - [ ] wm/niri.nix
  - [ ] wm/hyprland.nix
- [ ] Step 4: aggregate modules 削除 (common.nix, home/common.nix)
- [ ] Step 5: flake.nix paths 更新
- [ ] Step 6: host files 更新
  - [ ] coconut/default.nix
  - [ ] berry/default.nix
  - [ ] pi4/default.nix
  - [ ] plum/default.nix
- [ ] Step 7: nix flake check で検証
