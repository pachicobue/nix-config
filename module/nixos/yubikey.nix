{ delib, pkgs, ... }:
delib.module {
  name = "yubikey";
  options.yubikey.enable = delib.boolOption false;
  nixos.ifEnabled = {
    services.pcscd.enable = true;
    environment.systemPackages = with pkgs; [
      yubikey-manager
      yubioath-flutter
    ];
  };
}
