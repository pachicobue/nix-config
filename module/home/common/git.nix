{commonConfig, ...}: {
  programs = {
    git = {
      enable = true;
      userName = "pachicobue";
      userEmail = commonConfig.userEmail;
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
    gitui = {
      enable = true;
      keyConfig = ''
        (
          move_left: Some(( code: Char('h'), modifiers: "")),
          move_right: Some(( code: Char('l'), modifiers: "")),
          move_up: Some(( code: Char('k'), modifiers: "")),
          move_down: Some(( code: Char('j'), modifiers: "")),
        )
      '';
    };
    lazygit = {
      enable = true;
    };
  };
}
