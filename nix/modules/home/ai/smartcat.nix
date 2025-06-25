{ pkgs, username, ... }:
{
  home.packages = [
    pkgs.smartcat
  ];

  home.file."/home/${username}/.config/smartcat/prompts.toml" = {
    source = ./prompts.toml;
  };
  age.secrets."smartcat_api_config_toml" = {
    symlink = true;
    path = "/home/${username}/.config/smartcat/.api_configs.toml";
    file = ../../../secrets/smartcat_api_config_toml.age;
    mode = "644";
  };
}
