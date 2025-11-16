{
  inputs,
  commonConfig,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default

    ../../module/nixos/common.nix
    ../../module/nixos/usb.nix
    ../../module/nixos/yubikey.nix
    # ../../module/nixos/netbird-client.nix
    # ../../module/nixos/tailscale.nix
  ];

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

  # WSL Configuration
  wsl = {
    enable = true;
    defaultUser = commonConfig.userName;
  };
}
