{ ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainbar = {
        height = 45;
        layer = "top";
        position = "top";
        spacing = 5;
        modules-left = [
          "custom/launcher"
        ];
        modules-center = [
          "hyprland/workspaces"
        ];
        modules-right = [
          "pulseaudio"
          "network"
          "clock"
          "custom/powermenu"
        ];
        "custom/launcher" = {
          interval = "once";
          format = "";
          on-click = "walker";
          tooltip = false;
        };
        "hyprland/workspaces" = {
          disable-scroll = false;
          all-outputs = true;
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
          };
        };
        pulseaudio = {
          format = "{icon}   {volume}%";
          format-icons = {
            headphone = "";
            headset = "";
            default = [ "" "" ""];
          };
          on-click = "pavucontrol";
        };
        network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "  wired ";
          format-disconnected = "󰲛  ";
          tooltip = false;
        };
        clock = {
          format = "  {:%H:%M}";
        };
        "custom/powermenu" = {
          format = "";
          on-click = "wleave";
          tooltip = false;
        };
      };
    };
    style = ''
      /* margin: top right bottom left */
      /* Spacing outside the element */

      /* padding: top right bottom left */
      /* Spacing inside the element */
      window#waybar {
        background-color: @crust;
        color: @text;
        transition-property: background-color;
        transition-duration: 0.5s;
        border-radius: 0px;
        transition-duration: .5s;
        margin: 16px 16px;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces button {
        color: @text;
        background: @background3;
        border-radius: 8px;
        padding: 0px 10px 0px 10px;
        margin: 7px 5px 10px 5px;
        border: 1px solid @border;
      }

      #workspaces button:hover {
        background: @surface0;
        color: @text;
      }

      #workspaces button.active {
        color: @crust;
        background: @overlay2;
        border: none; 
      }

      #custom-launcher,
      #clock,
      #network,
      #pulseaudio,
      #custom-powermenu{
        padding: 0px 20px;
        margin: 7px 0px 10px 0px;
      	border-radius: 8px;
        color: @crust;
      }

      #window,

      #custom-launcher {
        padding: 0px 25px 0px 20px;
        margin: 7px 0px 10px 20px;
        background-color: @mauve;
      }

      #pulseaudio {
        padding: 0px 20px 0px 17px;
        background-color: @teal;
      }

      #network {
        padding: 0px 15px 0px 20px;
        background-color: @green;
      }

      #clock {
        background-color: @peach;
      }

      #custom-powermenu {
        padding: 0px 25px 0px 20px;
        margin: 7px 20px 10px 0px;
        background-color: @maroon;
      }

      @keyframes blink {
        to {
          background-color: rgba(30, 34, 42, 0.5);
          color: #abb2bf;
        }
      }

      label:focus {
        background-color: #000000;
      }
    '';
  };
}
