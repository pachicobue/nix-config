{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "scheduled-reboot";
  options = with delib;
    moduleOptions {
      enable = boolOption host.isServer;
      onCalendar = strOption "*-*-* 08:00:00";
    };

  nixos.ifEnabled = {cfg, ...}: {
    systemd.timers.scheduled-reboot = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = cfg.onCalendar;
        Persistent = true;
        Unit = "scheduled-reboot.service";
      };
    };
    systemd.services.scheduled-reboot = {
      description = "Scheduled system reboot";
      serviceConfig = {
        Type = "oneshot";
        # RTC の無いマシン (pi4) では起動直後の時計が過去になっており、NTP 同期で時計が
        # 進んだ瞬間にタイマーが発火して再起動ループになる。起動直後は再起動しない
        ExecCondition = pkgs.writeShellScript "scheduled-reboot-condition" ''
          read -r uptime _ < /proc/uptime
          [ "''${uptime%.*}" -ge 3600 ]
        '';
        ExecStart = "${pkgs.systemd}/bin/systemctl reboot";
      };
    };
  };
}
