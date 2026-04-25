{delib, ...}:
delib.module {
  name = "sudo";
  nixos.always = {
    security = {
      sudo.enable = false;
      sudo-rs.enable = true;
    };
  };
}
