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
        ExecStart = "${pkgs.systemd}/bin/systemctl reboot";
      };
    };
  };
}
