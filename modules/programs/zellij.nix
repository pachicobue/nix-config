{delib, ...}:
delib.module {
  name = "programs.zellij";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.zellij = {
      enable = true;
      settings = {
        keybinds.normal._children = [
          {
            bind = {
              _args = ["Alt f"];
              ToggleFocusFullscreen = {};
            };
          }
          {
            bind = {
              _args = ["Alt t"];
              ToggleFloatingPanes = {};
            };
          }
        ];
        copy_on_select = true;
        show_startup_tips = false;
        move_hover_effects = true;
        focus_follows_mouse = true;
        ui = {
          rounded_corners = true;
        };
      };
      layouts = {
        # [ 左 | 右上 / 右下 ] の3ペイン。
        work = {
          layout._children = [
            {
              default_tab_template._children = [
                {children = {};}
                {
                  pane = {
                    _props = {
                      size = 1;
                      borderless = true;
                    };
                    _children = [{plugin._props.location = "zellij:compact-bar";}];
                  };
                }
              ];
            }
            {
              tab = {
                _props = {
                  name = "work";
                  focus = true;
                };
                _children = [
                  {
                    pane = {
                      _props.split_direction = "vertical";
                      _children = [
                        {pane._props.size = "50%";}
                        {
                          pane = {
                            _props = {
                              split_direction = "horizontal";
                              size = "50%";
                            };
                            _children = [{pane = {};} {pane = {};}];
                          };
                        }
                      ];
                    };
                  }
                ];
              };
            }
          ];
        };
      };
    };
  };
}
