{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "boot";
  options = with delib;
    moduleOptions {
      enable = boolOption (!host.wsl2Featured);
      loader = enumOption ["grub" "systemd-boot" "limine" "extlinux"] null;
      enablePlymouth = boolOption host.guiFeatured;
      emulatedSystems = listOfOption str [];
    };

  nixos.ifEnabled = {cfg, ...}: {
    boot = {
      loader = {
        grub = {
          enable = cfg.loader == "grub";
          devices = ["nodev"];
          efiSupport = true;
          configurationLimit = 10;
        };

        systemd-boot = {
          enable = cfg.loader == "systemd-boot";
          configurationLimit = 10;
        };

        limine = {
          enable = cfg.loader == "limine";
          efiSupport = true;
          efiInstallAsRemovable = true;
          maxGenerations = 10;
        };

        generic-extlinux-compatible = {
          enable = cfg.loader == "extlinux";
          configurationLimit = 3;
        };

        timeout = 5;
      };

      plymouth = {
        enable = cfg.enablePlymouth;
        logo = "${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake-white.png";
      };

      tmp.cleanOnBoot = true;

      binfmt = {inherit (cfg) emulatedSystems;};
    };
  };
}
