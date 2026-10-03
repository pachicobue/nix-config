{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "services.sshd";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    # Tailscale SSHで管理するため鍵登録はしない
    # これは全マシンが物理アクセス可能であることを前提としている
    # リモートマシンを管理する場合は Tailscaleのauthkeyを設定して自動起動可能する
    users.users.sho.openssh.authorizedKeys.keys = [];
    users.users.root.openssh.authorizedKeys.keys = [];
    services.openssh = {
      enable = true;
      settings = {
        X11Forwarding = host.x11Featured;
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
    };
    # enableAllTerminfo は壊れやすい端末 (rxvt-unicode 等) まで巻き込むので必要な分だけ入れる
    environment.systemPackages = with pkgs; [
      alacritty.terminfo
      rio.terminfo
      ghostty.terminfo
    ];
  };
}
