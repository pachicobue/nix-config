{ lib, pkgs, ... }:
{
  programs.kitty = lib.mkForce {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = true;
      background_opacity = "0.8";
    };
  };
}
