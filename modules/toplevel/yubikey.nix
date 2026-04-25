{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "yubikey";
  options = delib.singleEnableOption true;
  nixos.ifEnabled = {
    services.pcscd.enable = true;
    environment.systemPackages = with pkgs; [
      yubikey-manager
      yubioath-flutter
    ];
  };
}
