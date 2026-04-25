{delib, ...}:
delib.module {
  name = "commands";
  options = with delib;
    delib.moduleOptions {
      # 明示的に起動する必要があるコマンド(systemdで起動する場合は不要)
      shouldAutostart = listOfOption [str] [];
      # デフォルトコマンド
      default = {
        editor = listOfOption str [];
        browser = listOfOption str [];
        terminal = listOfOption str [];
        launcher = listOfOption str [];
      };
    };
}
