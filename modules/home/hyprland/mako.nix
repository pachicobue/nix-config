{ ... }:
{
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
    };
  };
  catppuccin.mako = {
    enable = true;
  };
}
