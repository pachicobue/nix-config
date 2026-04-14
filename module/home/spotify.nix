{ delib, ... }:
delib.module {
  name = "spotify";
  options.spotify.enable = delib.boolOption false;
  home.ifEnabled.programs.spotify-player.enable = true;
}
