{
  delib,
  host,
  ...
}:
delib.module {
  name = "services.pipewire";
  options = delib.singleEnableOption host.isPC;
  nixos.ifEnabled = {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    services.pulseaudio.enable = false;
  };
}
