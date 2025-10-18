{hostConfig, ...}: {
  networking.interfaces."${hostConfig.iface}".wakeOnLan = {
    enable = true;
    policy = ["magic"];
  };
}
