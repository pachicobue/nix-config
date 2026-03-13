{inputs, ...}: {
  imports = [
    inputs.noctalia-shell.homeModules.default
  ];

  # configure options
  programs.noctalia-shell = {
    enable = true;
    settings = {
    };
  };
}
