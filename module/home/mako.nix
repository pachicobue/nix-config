{
  lib,
  hostConfig,
  ...
}:
lib.mkIf (hostConfig.desktop == "wayland") {
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
    };
  };
}
