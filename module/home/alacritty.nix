{ delib, ... }:
delib.module {
  name = "alacritty";
  options.alacritty.enable = delib.boolOption false;
  home.ifEnabled.programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 10;
          y = 5;
        };
      };
    };
  };
}
