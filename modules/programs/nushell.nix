{delib, ...}:
delib.module {
  name = "programs.nushell";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    home.shell.enableNushellIntegration = true;
    programs.nushell = {
      enable = true;
      settings = {
        show_banner = false;
        completions = {
          external.enable = true;
        };
      };
      extraConfig = ''
        def --wrapped e [...args] {
          run-external $env.EDITOR ...$args
        }
      '';
    };
  };
}
