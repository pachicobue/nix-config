{
  delib,
  lib,
  ...
}: let
  noctaliaCmd = cmd: ["noctalia" "msg"] ++ (lib.splitString " " cmd);
in
  delib.module {
    name = "programs.noctalia";
    options = with delib;
      moduleOptions {
        enable = boolOption false;
        defaultLauncher = boolOption false;
      };

    myconfig.ifEnabled = {cfg, ...}: {
      commands.default.launcher = lib.optionals cfg.defaultLauncher (noctaliaCmd "panel-toggle launcher");
    };

    home.ifEnabled = {myconfig, ...}: let
      pictureDir = myconfig.xdg.userDirs.pictures;
    in {
      programs.noctalia = {
        enable = true;
        # graphical-session.target に紐づけて起動する
        systemd.enable = true;
        settings = {
          shell = {
            avatar_path = "${pictureDir}/pachico.png";
            # サービス再起動時に noctalia から起動したアプリが巻き添えで落ちないようにする
            launch_apps_as_systemd_services = true;
            screen_corners.enabled = true;
            # 通常の検索結果に電卓の結果を混ぜない
            launcher.providers.calculator.global = false;
          };
          lockscreen.lock_before_suspend = false;
          lockscreen_widgets.enabled = false;

          location = {
            auto_locate = true;
            sunrise = "6:00";
            sunset = "18:00";
          };
          nightlight = {
            enabled = true;
            temperature_day = 6000;
            temperature_night = 5000;
          };

          # 配色・フォントはstylixのnoctaliaターゲットが設定する。

          wallpaper = {
            directory = "${pictureDir}/wallpapers";
            automation = {
              enabled = true;
              interval_seconds = 600;
              order = "random";
            };
          };

          bar.main = {
            position = "right";
            capsule = true;
            start = ["control-center" "launcher" "notifications" "media"];
            center = ["workspaces"];
            end = ["battery" "volume" "brightness" "clock"];
          };
          widget = {
            clock = {
              vertical_format = "{:%H\n%M}";
              tooltip_format = "{:%m/%d(%a), %H:%M}";
            };
          };

          # 画面オフ → ロック → サスペンド
          idle.behavior = {
            screen-off = {
              enabled = true;
              timeout = 600;
              action = "screen_off";
            };
            lock = {
              enabled = true;
              timeout = 900;
              action = "lock";
            };
            suspend = {
              enabled = true;
              timeout = 1800;
              action = "suspend";
            };
          };

          brightness = {
            enable_ddcutil = true;
            minimum_brightness = 0.05;
          };
        };
      };
    };
  }
