{...}: let
  genUdev = vid: pid: ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="${vid}", ATTRS{idProduct}=="${pid}", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
  devices = [
    {
      name = "crkbd";
      vid = "4653";
      pid = "0001";
    }
    {
      name = "keyball44";
      vid = "5957";
      pid = "0400";
    }
    {
      name = "7sPro";
      vid = "3265";
      pid = "000A";
    }
  ];
in {
  services.udev.extraRules =
    builtins.concatStringsSep "\n" (map (dev: genUdev dev.vid dev.pid) devices);
}
