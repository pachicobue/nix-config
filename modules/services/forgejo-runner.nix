{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "services.forgejo-runner";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      url = strOption "http://localhost:3000";
      # コンテナランタイムを使わず、ホスト上で直接ジョブを実行する
      labels = listOfOption str ["native:host"];
      # ランナー固有のID (`uuidgen`等で生成した固定値。機密情報ではない)
      uuid = strOption "";
    };

  nixos.ifEnabled = {
    cfg,
    myconfig,
    ...
  }: {
    # デフォルトのgitea-actions-runnerパッケージはGitea向けで、
    # Forgejo本体とのActions API互換性がずれているため、Forgejo専用ビルドを使う
    #
    # register経由の登録(.runnerファイル方式)は新しいforgejo-runnerで非推奨・
    # 動作しなくなっているため、config.yamlのserver.connectionsに直接
    # token_url(file://)でシークレットを渡し、registerをバイパスする
    # gitea-actions-runnerはDynamicUser(固定UIDなし)で動くため、
    # token_urlを読む本体プロセスから読めるようパーミッションを開放する
    age.secrets.forgejo-runner.mode = "0444";

    services.gitea-actions-runner = {
      package = pkgs.forgejo-runner;
      instances.default = {
        enable = true;
        name = host.name;
        inherit (cfg) url labels;
        tokenFile = myconfig.agenix-rekey.secretPaths.forgejo-runner;
        settings.server.connections.${host.name} = {
          inherit (cfg) url labels uuid;
          token_url = "file://${myconfig.agenix-rekey.secretPaths.forgejo-runner}";
        };
      };
    };
  };
}
