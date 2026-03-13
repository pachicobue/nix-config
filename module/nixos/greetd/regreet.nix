{
  pkgs,
  lib,
  hostConfig,
  ...
}:
lib.mkIf (hostConfig.desktop == "wayland") {
  programs.regreet.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${lib.getExe pkgs.cage} -s -m last -- ${lib.getExe pkgs.regreet}";
      };
    };
  };
}
