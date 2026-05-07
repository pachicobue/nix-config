{delib, ...}:
delib.host {
  name = "plum";
  system = "x86_64-linux";
  type = "virtual";
  features = ["wsl2" "cli"];

  myconfig = {...}: {
    state-version.nixos = "25.05";
    state-version.home = "25.05";
    boot.loader = "grub";
  };
}
