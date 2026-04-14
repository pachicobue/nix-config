{ delib, inputs, config, ... }:
delib.host {
  name = "plum";
  system = "x86_64-linux";

  myconfig = { ... }: {
    host.desktop = "wayland";
    host.network = {
      useDhcp = true;
      iface = { };
    };
    usb.enable = true;
    yubikey.enable = true;
    "claude-code".enable = true;
    helix.enable = true;
  };

  nixos = { ... }: {
    system.stateVersion = "25.05";
    networking.hostName = "plum";
    nixpkgs.config.allowUnfree = true;

    imports = [ inputs.nixos-wsl.nixosModules.default ];

    wsl = {
      enable = true;
      defaultUser = config.myconfig.constants.userName;
    };

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.debian.pcsc-lite.access_card" &&
            subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
      });
      polkit.addRule(function(action, subject) {
        if (action.id == "org.debian.pcsc-lite.access_pcsc" &&
            subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
      });
    '';
  };

  home = { ... }: {
    home.stateVersion = "25.05";
    programs.helix.defaultEditor = true;
  };
}
