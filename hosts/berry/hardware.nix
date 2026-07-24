{
  delib,
  config,
  lib,
  modulesPath,
  ...
}:
delib.host {
  name = "berry";

  nixos = {
    imports = [(modulesPath + "/installer/scan/not-detected.nix")];

    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "sdhci_pci"
    ];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel"];
    boot.extraModulePackages = [];
    # RTL8821CE(rtw88_8821ce)がAER割り込みスレッドとshutdown処理でデッドロックし、
    # 定期リブート時にハングする不具合の回避。有線(enp1s0)で接続済みのため無効化。
    boot.blacklistedKernelModules = ["rtw88_8821ce"];
    swapDevices = [];
    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
