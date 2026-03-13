{
  pkgs,
  lib,
  hostConfig,
  ...
}:
lib.mkIf (hostConfig.desktop != "none") {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${lib.getExe pkgs.tuigreet} --time --remember --remember-session";
      };
    };
  };
}
