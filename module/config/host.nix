{ delib, ... }:
delib.module {
  name = "host";
  options.host = with delib; {
    desktop = strOption "none";
    network = submoduleOption {
      options = {
        useDhcp = boolOption true;
        iface = submoduleOption {
          options = {
            name = strOption "";
            mac = strOption "";
            address = strOption "";
            enableWol = boolOption false;
          };
        };
      };
    };
  };
}
