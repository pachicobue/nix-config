{delib, ...}:
delib.module {
  name = "services.hyprsunset";
  options = delib.singleEnableOption false;
  home.ifEnabled = {
    services.hyprsunset = {
      enable = true;
      transitions = {
        sunrise = {
          calendar = "*-*-* 06:00:00";
          requests = [
            ["temperature" "6500"]
          ];
        };
        sunset = {
          calendar = "*-*-* 20:00:00";
          requests = [
            ["temperature" "4000"]
          ];
        };
      };
    };
  };
}
