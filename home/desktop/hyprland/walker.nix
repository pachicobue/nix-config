{ inputs, ... }:
{
  imports = [
    inputs.walker.homeManagerModules.default
  ];
  programs.walker = {
    enable = true;
    runAsService = true;
    config = {
      theme = "catppuccin";
      builtins = {
        applications = {
          weight = 5;
          name = "applications";
          placeholder = "Applications";
          actions = {
            enabled = true;
            hide_category = false;
            hide_without_query = true;
          };
          prioritize_new = true;
          hide_actions_with_empty_query = true;
          context_aware = true;
          refresh = true;
          show_sub_when_single = true;
          show_icon_when_single = true;
          show_generic = true;
        };
      };
    };
  };
}
