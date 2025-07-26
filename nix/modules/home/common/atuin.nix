{ ... }:
{
  programs.atuin = {
    enable = true;
    settings = {

    };
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
  };
}
