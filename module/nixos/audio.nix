{ delib, ... }:
delib.module {
  name = "audio";
  options.audio.enable = delib.boolOption false;
  nixos.ifEnabled = {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };
  };
}
