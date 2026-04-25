{
  delib,
  inputs,
  ...
}:
delib.host {
  name = "berry";

  nixos = {
    imports = [inputs.disko.nixosModules.disko];

    disko.devices.disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/ata-CYX-SSD-S1000_230919000201S5127572";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "2G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };

    disko.devices.disk.extra = {
      type = "disk";
      device = "/dev/disk/by-id/ata-KIOXIA-EXCERIA_SATA_SSD_Z0AB821TKJ72";
      content = {
        type = "gpt";
        partitions.data = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = ["-f"];
            subvolumes = {
              "/media" = {
                mountpoint = "/media";
                mountOptions = [
                  "compress=zstd:1"
                  "noatime"
                  "space_cache=v2"
                ];
              };
              "/media-snapshots" = {
                mountpoint = "/media/.snapshots";
                mountOptions = ["noatime"];
              };
            };
          };
        };
      };
    };

    services.btrbk.instances.media = {
      onCalendar = "weekly";
      settings = {
        snapshot_preserve_min = "latest";
        snapshot_preserve = "4w";
        volume."/media" = {
          subvolume = "media";
          snapshot_dir = ".snapshots";
        };
      };
    };
  };
}
