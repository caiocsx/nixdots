{ theme, ... }:
{
  services.swaync = {
    enable = true;
    settings = {
      positionX = "left";
      positionY = "top";
      layer = "overlay";
      cssPriority = "user";
      control-center-layer = "top";
      layer-shell = true;
      fit-to-screen = true;
      control-center-width = 450;
      control-center-margin-top = theme.gaps.outer;
      control-center-margin-right = 0;
      control-center-margin-bottom = theme.gaps.outer;
      control-center-margin-left = theme.gaps.outer;
      notification-window-width = 350;
      notification-icon-size = 64;
      notification-body-image-width = 200;
      notification-body-image-height = 200;
      notification-2fa-action = true;
      notification-inline-replies = true;
      timeout-low = 3;
      timeout = 4;
      timeout-critical = 5;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = true;
      hide-on-action = true;
      script-fail-notify = true;
      widgets = [
        "mpris"
        "title"
        "dnd"
        "notifications"
        "buttons-grid"
      ];
      widget-config = {
        buttons-grid = {
          buttons-per-row = 4;
          actions = [
            {
              label = "";
              command = "swaync-client -cp && sleep 0.25 && colorpicker";
            }
            {
              label = "󰃟";
              command = "bluefilter --toggle";
            }
            {
              label = "";
              command = "swaync-client -cp && screenshot --region";
            }
            {
              label = "";
              command = "kitty btop";
            }
          ];
        };
        mpris = {
          show-album-art = "when-available";
          autohide = true;
          blacklist = [ "playerctld" ];
        };
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "󰆴";
        };
        dnd = {
          text = "Do Not Disturb";
        };
      };
    };
    style = ''
      @import url("${theme.css.gtk}");

      * {
        outline: none;
        box-shadow: none;
        font-family: ${theme.fonts.monospace.proportional};
        font-size: 16px;
        color: @foreground;
      }

      .control-center {
        background-color: alpha(@background, ${toString theme.opacity.popup});
        border-radius: ${toString theme.borders.radius}px;
      }

      .control-center-list {
        background-color: transparent;
      }

      .control-center .notification-background .close-button,
      .notification-group-close-button {
        opacity: 0;
      }

      .notification-group {
        background-color: transparent;
      }

      .notification {
        padding: 14px;
        background-color: alpha(@background, 0.9);
        border-radius: ${toString theme.borders.radius}px;
      }

      .notification * {
        background-color: transparent;
      }

      .right * {
        opacity: 0;
      }

      .notification-content {
        margin: 0;
        padding: 0;
      }

      .summary {
        padding-top: 2px;
        font-size: 16px;
        font-weight: bold;
      }

      .time {
        padding-top: 2px;
        font-size: 12px;
        color: @muted;
      }

      .body {
        padding-top: 6px;
        font-size: 14px;
      }

      .notification image {
        margin-right: 12px;
        border-radius: 0;
      }

      .widget-mpris-title {
        font-size: 18px;
        font-weight: 700;
      }

      .widget-title {
        margin: 8px 16px;
      }

      .widget-title > label {
        font-size: 18px;
        font-weight: 700;
      }

      .widget-title > button {
        padding: 4px 16px;
        border-radius: 12px;
        background-color: alpha(@red, 0.12);
        transition: background-color 0.2s ease;
      }

      .widget-title > button:hover {
        background-color: alpha(@red, 0.22);
      }

      .widget-title > button > * {
        font-size: 16px;
      }

      .widget-dnd {
        margin: 4px 16px 12px;
      }

      .widget-dnd > label {
        font-size: 14px;
      }

      .widget-dnd > switch {
        border-radius: 12px;
        background-color: alpha(@muted, 0.5);
      }

      .widget-dnd > switch:checked {
        background-color: @foreground;
      }

      .widget-dnd > switch slider {
        background-color: @background;
        border-radius: 10px;
      }

      .widget-dnd > switch:checked slider {
        background-color: @surface;
        border-radius: 10px;
      }

      .widget-buttons-grid {
        margin: 12px 16px 16px;
        background-color: transparent;
      }

      .widget-buttons-grid > flowbox > flowboxchild>button {
        padding: 10px 8px;
        background-color: transparent;
        border-radius: 8px;
        box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.2), 0 0 8px rgba(0, 0, 0, 0.3);
        transition: background-color 0.2s ease;
      }

      .widget-buttons-grid > flowbox > flowboxchild>button:hover {
        background-color: alpha(@accent, 0.15);
      }

      .widget-buttons-grid > flowbox > flowboxchild > button label {
        font-size: 14px;
        transition: color 0.2s ease;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button:hover label {
        color: @accent;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked {
        background-color: @accent;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked label {
        color: @background;
      }
    '';
  };
}
