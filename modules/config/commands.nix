{delib, ...}:
delib.module {
  name = "commands";
  options = with delib;
    delib.moduleOptions {
      # デフォルトコマンド
      default = {
        browser = listOfOption str [];
        terminal = listOfOption str [];
        launcher = listOfOption str [];
      };
    };
}
