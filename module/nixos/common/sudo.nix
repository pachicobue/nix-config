{ delib, ... }:
delib.module {
  name = "nixos.sudo";
  nixos.always.security = {
    sudo.enable = false;
    sudo-rs.enable = true;
  };
}
