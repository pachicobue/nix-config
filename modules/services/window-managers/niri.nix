{
  delib,
  host,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "services.windowManager.niri";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
    };

  home.ifEnabled = {myconfig, ...}: let
    inherit (myconfig.commands.default) browser terminal launcher;
    pictureDir = myconfig.xdg.userDirs.pictures;

    # [browser][terminal(zellij: 3ペイン)] の列構成を作る。
    # ペイン分割はzellijのworkレイアウト側で行う。
    # プロセスの起動順とウィンドウが実際にマップされる順は一致しない
    # (例: browserの方がterminalより起動が遅くcolumnが後ろにずれる) ため、
    # 固定sleepではなくwindows数の増加を待ってから次をspawnする。
    startupScript = pkgs.writeShellScript "niri-startup" ''
      wait_for_new_window() {
        before=$1
        for _ in $(seq 1 100); do
          [ "$(niri msg -j windows | jq 'length')" -gt "$before" ] && return
          sleep 0.1
        done
      }
      spawn_and_wait() {
        n=$(niri msg -j windows | jq 'length')
        niri msg action spawn -- "$@"
        wait_for_new_window "$n"
      }

      spawn_and_wait ${lib.escapeShellArgs browser}
      spawn_and_wait ${lib.escapeShellArgs (terminal ++ ["-e" (lib.getExe pkgs.zellij) "attach" "-c" "pachico-work"])}
    '';
  in {
    assertions = [
      {
        assertion = host.waylandFeatured;
        message = "[niri] Need 'wayland' feature.";
      }
      {
        assertion = browser != [];
        message = "[niri] Need default browser command to be set.";
      }
      {
        assertion = terminal != [];
        message = "[niri] Need terminal browser command to be set.";
      }
      {
        assertion = launcher != [];
        message = "[niri] Need launcher browser command to be set.";
      }
    ];

    home.packages = with pkgs; [gcr_4];
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
        gnome-keyring
      ];
      config.niri = {
        default = ["gnome" "gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
      };
    };
    # Authentication agentは固定(こだわりなし)
    services.hyprpolkitagent.enable = true;
    services.gnome-keyring = {
      enable = true;
      components = ["pkcs11" "secrets"];
    };

    wayland.windowManager.niri = {
      enable = true;
      # portalはxdg.portalで自前管理するため、niriモジュール側では入れない。
      portalPackage = null;
      settings = {
        input = {
          touchpad = {
            tap = {};
            dwt = {};
            natural-scroll = {};
          };
          warp-mouse-to-focus = {};
          focus-follows-mouse = {};
        };
        cursor = {
          xcursor-theme = "default";
          xcursor-size = 24;
          hide-when-typing = {};
        };
        hotkey-overlay.skip-at-startup = {};
        screenshot-path = "${pictureDir}/Screenshots/%Y%m%d_%H%M%s.png";
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        spawn-at-startup = ["${startupScript}"];

        layout = {
          gaps = 8;
          always-center-single-column = {};
          center-focused-column = "never";
          # 各ウィンドウは画面幅いっぱいで開き、Mod+H/Lでカラム間を移動する。
          default-column-width.proportion = 1.0;
          preset-column-widths._children = [
            {proportion = 0.5;}
            {proportion = 1.0;}
          ];
        };

        window-rule = {
          geometry-corner-radius = [20 20 20 20];
          clip-to-geometry = true;
          draw-border-with-background = false;
        };

        layer-rule = {
          match._props.namespace = "^noctalia-overview*";
          place-within-backdrop = true;
        };

        overview.workspace-shadow.on = {};
        debug.honor-xdg-activation-with-invalid-serial = {};

        binds = {
          "Mod+Shift+Slash".show-hotkey-overlay = {};
          "Ctrl+Alt+Delete".quit = {};
          "Ctrl+Alt+Q".quit = {};
          "Mod+Q" = {
            _props.repeat = false;
            close-window = {};
          };
          "Mod+T" = {
            _props.repeat = false;
            spawn = terminal;
          };
          "Mod+B" = {
            _props.repeat = false;
            spawn = browser;
          };
          "Mod+D" = {
            _props.repeat = false;
            spawn = launcher;
          };

          "Mod+H".focus-column-left = {};
          "Mod+J".focus-window-down = {};
          "Mod+K".focus-window-up = {};
          "Mod+L".focus-column-right = {};
          "Mod+Ctrl+H".move-column-left = {};
          "Mod+Ctrl+J".move-window-down = {};
          "Mod+Ctrl+K".move-window-up = {};
          "Mod+Ctrl+L".move-column-right = {};
          "Mod+Shift+H".focus-monitor-left = {};
          "Mod+Shift+J".focus-monitor-down = {};
          "Mod+Shift+K".focus-monitor-up = {};
          "Mod+Shift+L".focus-monitor-right = {};
          "Mod+Shift+Ctrl+H".move-column-to-monitor-left = {};
          "Mod+Shift+Ctrl+J".move-column-to-monitor-down = {};
          "Mod+Shift+Ctrl+K".move-column-to-monitor-up = {};
          "Mod+Shift+Ctrl+L".move-column-to-monitor-right = {};

          "Mod+U".focus-workspace-down = {};
          "Mod+I".focus-workspace-up = {};
          "Mod+Ctrl+U".move-column-to-workspace-down = {};
          "Mod+Ctrl+I".move-column-to-workspace-up = {};
          "Mod+Shift+U".move-workspace-down = {};
          "Mod+Shift+I".move-workspace-up = {};

          "Mod+Comma".consume-window-into-column = {};
          "Mod+Period".expel-window-from-column = {};
          "Mod+BracketLeft".consume-or-expel-window-left = {};
          "Mod+BracketRight".consume-or-expel-window-right = {};

          "Mod+F".maximize-column = {};
          "Mod+Ctrl+F".expand-column-to-available-width = {};
          "Mod+Shift+F".fullscreen-window = {};

          "Mod+r".switch-preset-column-width = {};
          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";
          "Mod+Shift+Minus".set-window-height = "-10%";
          "Mod+Shift+Equal".set-window-height = "+10%";

          "Mod+V".toggle-window-floating = {};
          "Mod+W".toggle-column-tabbed-display = {};

          "Mod+S".screenshot._props.show-pointer = false;
          "Mod+Shift+S".screenshot-screen._props.show-pointer = false;
        };
      };
    };
  };
}
