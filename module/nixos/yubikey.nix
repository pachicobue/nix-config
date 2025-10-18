{
  pkgs,
  commonConfig,
  ...
}: let
  id = "pam://${commonConfig.userName}";
  mappingFile = "u2f-mapping";
in {
  services.pcscd.enable = true;
  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubioath-flutter
  ];
  environment.etc."${mappingFile}" = {
    text = builtins.concatStringsSep "" ([commonConfig.userName] ++ commonConfig.u2fMappings);
    mode = "0644";
    user = "root";
    group = "root";
  };
  security.pam = {
    u2f = {
      enable = true;
      control = "sufficient";
      settings = {
        interactive = true;
        cue = true;
        authfile = "/etc/${mappingFile}";
        appid = id;
        origin = id;
      };
    };
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };
}
