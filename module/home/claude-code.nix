{pkgs, ...}: {
  programs.claude-code = {
    enable = true;
    settings = {
      sandbox = {
        enabled = true;
        autoAllowBashIfSandboxed = true;
      };
      permissions = {
        deny = [
          "Bash(rm -rf *)"
          "Bash(sudo *)"
        ];
        ask = [
          "Bash(rm *)"
          "Bash(mv *)"
        ];
      };
    };
    rules = {
      jj = ''
        # jujutsu(jj) の使い方

        ## 基本

        - gitコマンドは使用せず `jj` を使用する
        - コミットメッセージを生成する場合は claude-code 自動生成である注記を加える
        - `jj git push` は行わない
            - gpg署名が必要なため

        ## 主要コマンド

        - jj status # 状態確認
        - jj diff # 差分表示
        - jj describe -m "msg" # コミットメッセージ設定
        - jj new main -m "msg" # 新しい変更セット作成(作業内容を補足)
        - jj bookmark set main -r @ # ブックマーク設定
      '';
    };
  };
  home.packages = [
    pkgs.bubblewrap
  ];
}
