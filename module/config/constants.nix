{ delib, commonConfig, ... }:
delib.module {
  name = "constants";
  options.myconfig.constants = with delib; {
    userName = readOnly (strOption commonConfig.userName);
    userFullName = readOnly (strOption commonConfig.userFullName);
    userEmail = readOnly (strOption commonConfig.userEmail);
    userPassHash = readOnly (strOption commonConfig.userPassHash);
    rootPassHash = readOnly (strOption commonConfig.rootPassHash);
    gpg = readOnly (strOption commonConfig.gpg);
    sshKeys = readOnly (listOfOption str commonConfig.sshKeys);
    network = readOnly (submoduleOption {
      options = {
        gateway = strOption commonConfig.network.gateway;
        dns = strOption commonConfig.network.dns;
      };
    } { });
    wolHosts = readOnly (listOfOption (submodule {
      options = {
        name = strOption "";
        mac = strOption "";
      };
    }) commonConfig.wolHosts);
  };
}
