{ pkgs, theme, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.main = {
      layer = "top";
      position = "top";
      margin = "8px 8px 0 8px";
      modules-left = [ "group/group-left" ];
      modules-center = [ "group/group-center" ];
      modules-right = [ "group/group-right" ];
      "group/group-left" = {
        orientation = "inherit";
        modules = [
          "custom/nixos"
          "custom/notification"
          "clock"
          "privacy"
          "tray"
        ];
      };
      "custom/nixos" = {
        format = "󱄅";
        on-click = "launcher";
        on-click-right = "kitty";
        tooltip = false;
      };
      "custom/notification" = {
        format = "{icon}";
        format-icons = {
          notification = "󱅫";
          none = "󰂜";
          dnd-notification = "󰂠";
          dnd-none = "󰪓";
          inhibited-notification = "󰂛";
          inhibited-none = "󰪑";
          dnd-inhibited-notification = "󰂛";
          dnd-inhibited-none = "󰪑";
        };
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        return-type = "json";
        tooltip = true;
        escape = true;
      };
      clock = {
        format = "{:%H:%M:%S}";
        format-alt = "{:%H:%M - %B %d, %Y}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "year";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          format = {
            months = "<span color='${theme.colors.blue}'><b>{}</b></span>";
            days = "<span color='${theme.colors.foreground}'><b>{}</b></span>";
            weeks = "<span color='${theme.colors.cyan}'><b>W{}</b></span>";
            weekdays = "<span color='${theme.colors.muted}'><b>{}</b></span>";
            today = "<span color='${theme.colors.red}'><b><u>{}</u></b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
        interval = 1;
      };
      privacy = {
        modules = [
          {
            type = "screenshare";
            tooltip = false;
          }
          {
            type = "audio-in";
            tooltip = false;
          }
          {
            type = "location";
            icon-name = "location-services-active-symbolic";
          }
        ];
        icon-size = 14;
        icon-spacing = 10;
        transition-duration = 250;
      };
      tray = {
        icon-size = 14;
        spacing = 10;
      };
      "group/group-center" = {
        orientation = "inherit";
        modules = [ "hyprland/workspaces" ];
      };
      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          active = "󰝥";
          default = "󰝥";
          empty = "󰝥";
        };
        persistent-workspaces = {
          "*" = [
            1
            2
            3
            4
            5
          ];
        };
      };
      "group/group-right" = {
        orientation = "inherit";
        modules = [
          "pulseaudio#microphone"
          "group/audio"
          "group/brightness"
          "group/group-system"
        ];
      };
      "pulseaudio#microphone" = {
        format = "{format_source}";
        format-source = "󰍬";
        format-source-muted = "󰍭";
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        on-scroll-up = "";
        on-scroll-down = "";
        tooltip = false;
      };
      "group/audio" = {
        orientation = "inherit";
        drawer = {
          transition-left-to-right = false;
          transition-duration = 400;
        };
        modules = [
          "pulseaudio"
          "pulseaudio/slider"
        ];
      };
      "pulseaudio/slider" = {
        orientation = "horizontal";
        min = 0;
        max = 100;
      };
      pulseaudio = {
        format = "{icon}";
        format-muted = "󰝟";
        format-icons = {
          headphone = "󰋋";
          headset = "󰋎";
          headset-muted = "󰋐";
          default = [ "󰕾" ];
        };
        on-click = "pavucontrol";
        on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        tooltip-format = "Volume: {volume}%";
        ignored-sinks = [ "Easy Effects Sink" ];
        tooltip = true;
      };
      "group/brightness" = {
        orientation = "inherit";
        drawer = {
          transition-left-to-right = false;
          transition-duration = 400;
        };
        modules = [
          "backlight"
          "backlight/slider"
        ];
      };
      "backlight/slider" = {
        orientation = "horizontal";
        min = 5;
        max = 100;
      };
      backlight = {
        format = "{icon}";
        format-icons = [
          "󰃞"
          "󰃝"
          "󰃟"
          "󰃠"
        ];
        tooltip-format = "Brightness: {percent}%";
        tooltip = true;
      };
      "group/group-system" = {
        orientation = "inherit";
        modules = [
          "bluetooth"
          "network"
          "battery"
          "custom/power"
        ];
      };
      bluetooth = {
        format-on = "󰂯";
        format-off = "󰂲";
        format-disabled = "󰂲";
        format-connected = "󰂱";
        format-no-controller = "󰂳";
        tooltip-format = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_address}";
        tooltip-format-enumerate-connected-battery = "{device_alias} | Battery {device_battery_percentage}%";
        on-click = "kitty -e bluetui";
        on-click-right = "rfkill toggle bluetooth";
        tooltip = true;
      };
      network = {
        format-icons = {
          wifi = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          ethernet = "󰈀";
          linked = "󰌚";
          disconnected = "󰌙";
          disabled = "󰤭";
        };
        format-wifi = "{icon}";
        format-ethernet = "{icon}";
        format-linked = "{icon}";
        format-disconnected = "{icon}";
        format-disabled = "{icon}";
        tooltip-format = "{ifname}";
        tooltip-format-wifi = "{essid}\nSignal: {signalStrength}%\nIP: {ipaddr}/{cidr}\n↓ {bandwidthDownBytes}  ↑ {bandwidthUpBytes}";
        tooltip-format-ethernet = "{ifname}\nIP: {ipaddr}/{cidr}\n↓ {bandwidthDownBytes}  ↑ {bandwidthUpBytes}";
        tooltip-format-linked = "{ifname}\nConnected, waiting for IP";
        tooltip-format-disconnected = "Disconnected";
        tooltip-format-disabled = "Disabled";
        on-click = "kitty -e nmtui";
        on-click-right = "rfkill toggle wifi";
        tooltip = true;
        max-length = 20;
        interval = 5;
      };
      battery = {
        states = {
          warning = 20;
          critical = 10;
        };
        events = {
          on-charging = "${pkgs.libnotify}/bin/notify-send -u normal 'Power' 'Connected to AC power'";
          on-charging-100 = "${pkgs.libnotify}/bin/notify-send -u normal 'Battery' 'Battery is fully charged'";
          on-discharging = "${pkgs.libnotify}/bin/notify-send -u normal 'Power' 'Running on battery'";
          on-discharging-warning = "${pkgs.libnotify}/bin/notify-send -u normal 'Battery Warning' 'Battery level is low'";
          on-discharging-critical = "${pkgs.libnotify}/bin/notify-send -u critical 'Battery Critical' 'Battery level is critically low'";
        };
        format = "{icon}";
        format-icons = {
          default = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          charging = [
            "󰢟"
            "󰢜"
            "󰂆"
            "󰂇"
            "󰂈"
            "󰢝"
            "󰂉"
            "󰢞"
            "󰂊"
            "󰂋"
            "󰂅"
          ];
        };
        format-critical = "󰂃";
        tooltip-format = "{capacity}% - {time} remaining";
        tooltip-format-charging = "Charging: {capacity}% - {time} until full";
        tooltip = true;
        interval = 10;
      };
      "custom/power" = {
        format = "󰤆";
        on-click = "power-menu";
        tooltip = false;
      };
    };
    style = ''
      @import url("${theme.css.gtk}");

      @keyframes battery-blink {
        from {
          opacity: 1;
        }
        to {
          opacity: 0.3;
        }
      }

      * {
        all: unset;
        box-shadow: none;
        border: none;
        font-family: ${theme.fonts.monospace.proportional};
        font-size: 16px;
      }

      window#waybar {
        background-color: transparent;
      }

      tooltip {
        border: 2px solid @surface;
        background: @background;
        border-radius: ${toString theme.borders.radius}px;
      }

      tooltip label {
        padding: 4px 6px;
        font-size: 14px;
        color: @foreground;
      }

      #custom-nixos,
      #custom-notification,
      #clock,
      #privacy,
      #tray,
      #pulseaudio.microphone,
      #pulseaudio,
      #backlight,
      #group-system {
        min-height: 30px;
        min-width: 25px;
        padding: 0 10px;
        margin: 0 4px;
        color: @foreground;
        background-color: alpha(@background, ${toString theme.opacity.popup});
        border-radius: ${toString theme.borders.radius}px;
        transition: color 0.3s ease;
      }

      #custom-notification:hover,
      #clock:hover,
      #privacy:hover,
      #pulseaudio.microphone:hover,
      #pulseaudio:hover,
      #backlight:hover,
      #bluetooth:hover,
      #network:hover,
      #battery:hover,
      #custom-power:hover {
        color: @accent;
      }

      #custom-nixos {
        font-size: 17px;
        color: @blue;
      }

      #clock {
        padding: 0 18px;
        font-size: 14px;
        font-feature-settings: "tnum";
      }

      #tray {
        padding: 0 14px;
      }

      #privacy {
        min-width: 0;
        padding: 0 14px;
      }

      #tray window decoration {
        padding: 6px 12px;
        background-color: alpha(@background, 0.9);
        border-radius: ${toString theme.borders.radius}px;
      }

      #workspaces {
        min-height: 30px;
        padding: 0 10px;
        margin: 0 4px;
        background-color: alpha(@background, ${toString theme.opacity.popup});
        border-radius: ${toString theme.borders.radius}px;
      }

      #workspaces button {
        padding: 0 5px;
        color: alpha(@muted, 0.4);
        transition: all 0.2s ease;
      }

      #workspaces button:hover {
        color: rgba(0, 0, 0, 0);
        text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 0.5);
        transition: all 0.5s ease;
      }

      #workspaces button.active {
        color: @muted;
        text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.5);
      }

      #workspaces button.empty {
        color: rgba(0, 0, 0, 0);
        text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 0.2);
      }

      #workspaces button.empty:hover {
        color: rgba(0, 0, 0, 0);
        text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 0.5);
        transition: all 0.5s ease;
      }

      #workspaces button.empty.active {
        color: @muted;
        text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.5);
      }

      #pulseaudio-slider,
      #backlight-slider {
        min-height: 30px;
        padding: 0 14px;
        margin: 0 4px;
        background-color: alpha(@background, ${toString theme.opacity.popup});
        border-radius: 8px;
      }

      #pulseaudio-slider slider,
      #backlight-slider slider {
        min-height: 0px;
        min-width: 0px;
      }

      #pulseaudio-slider trough,
      #backlight-slider trough {
        min-height: 8px;
        min-width: 100px;
        background-color: @surface;
        border-radius: 8px;
      }

      #pulseaudio-slider highlight,
      #backlight-slider highlight {
        min-width: 8px;
        min-height: 8px;
        background-color: @foreground;
        border-radius: 8px;
      }

      #bluetooth,
      #network,
      #battery,
      #custom-power {
        min-width: 20px;
        padding: 0 6px;
        transition: color 0.3s ease;
      }

      #battery.charging.warning,
      #battery.charging.critical {
        color: @green;
        animation: battery-blink 2s ease-in-out infinite alternate;
      }

      #battery.charging.warning:hover,
      #battery.charging.critical:hover {
        color: @green;
      }

      #battery.warning {
        color: @yellow;
        animation: battery-blink 2s ease-in-out infinite alternate;
      }

      #battery.warning:hover {
        color: @yellow;
      }

      #battery.critical {
        color: @red;
        animation: battery-blink 0.8s linear infinite alternate;
      }

      #battery.critical:hover {
        color: @red;
      }
    '';
  };
}
