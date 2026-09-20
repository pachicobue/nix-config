{delib, ...}:
delib.module {
  name = "programs.zellij";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.zellij = {
      enable = true;
      settings = {
        focus_follows_mouse = true;
        # `zellij attach -c pachico-work` で「あればattach、なければworkレイアウトで新規作成」になる。
        # niriのterminalでもssh先でも同じコマンドで同じ作業環境に入れる。
        # (session_name + attach_to_session の組はlayoutが無視されるため使わない: zellij 0.45.1で確認)
        default_layout = "work";
      };
      layouts = {
        # [ 左 | 右上 / 右下 ] の3ペイン。
        # 以前niriで [terminal][terminal x2 (縦積み)] と並べていた構成の再現。
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
