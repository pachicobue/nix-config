{
  delib,
  inputs,
  config,
  ...
}:
delib.host {
  name = "plum";
  system = "x86_64-linux";
  type = "virtual";
  network = {
    nic = [
      {
        name = "eno1";
        mac = "08:bf:b8:a5:74:f7";
        wakeOnLan = true;
      }
    ];
    sshPublicKey = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIurSBgviLvpzHnZOMuu7UEbw9sktSuVahUySjW0dquy sho@plum"
    ];
  };

  myconfig = {...}: {
    usb.enable = true;
    yubikey.enable = true;
    claude-code.enable = true;
    programs.helix.setAsDefaultEditor = true;
  };

  nixos = {...}: {
    system.stateVersion = "25.05";
    networking.hostName = "plum";
    networking.resolvconf.enable = false;
    nixpkgs.config.allowUnfree = true;

    imports = [inputs.nixos-wsl.nixosModules.default];

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

  home = {...}: {
    home.stateVersion = "25.05";
  };
}
