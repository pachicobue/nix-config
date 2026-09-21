{delib, ...}:
delib.module {
  name = "ntpd-rs";

  nixos.always = {
    # systemd-timesyncdの代替となるRust製NTPクライアント
    # 有効化するとservices.timesyncdは自動的にdisableされる
    services.ntpd-rs.enable = true;
  };
}
