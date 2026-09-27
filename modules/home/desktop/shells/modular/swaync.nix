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
      ];
      widget-config = {
        mpris = {
          show-album-art = "when-available";
          autohide = true;
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
        padding: 6px;
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
        margin-top: 4px;
        padding: 4px;
      }

      .summary {
        padding-top: 2px;
        font-weight: bold;
      }

      .time {
        padding-top: 2px;
        color: @muted;
      }

      .body {
        padding-top: 4px;
        font-size: 0.9rem;
      }

      .notification image {
        margin-right: 12px;
        border-radius: 0;
      }

      .widget-mpris-title {
        font-size: 18px;
        font-weight: 700;
      }

      .widget-title > button {
        padding: 2px 16px;
        border-radius: 12px;
        background-color: alpha(@red, 0.5);
        transition: all 0.4s ease-in-out;
      }

      .widget-title > button:hover {
        background-color: @red;
        box-shadow: 0px 0px 5px red;
      }

      .widget-title > *,
      .widget-title>button>* {
        font-size: 20px;
      }

      .widget-dnd > * {
        font-size: 20px;
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
        margin: 10px;
        background-color: transparent;
      }

      .widget-buttons-grid > flowbox > flowboxchild>button {
        padding: 10px 8px;
        background-color: transparent;
        border-radius: 8px;
        box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.2), 0 0 8px rgba(0, 0, 0, 0.3);
      }

      .widget-buttons-grid > flowbox > flowboxchild>button:hover {
        background-color: @accent;
        box-shadow: 0px 0px 2px rgba(0, 0, 0, 0.2);
        transition: all 0.5s ease;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button label {
        font-size: 20px;
        transition: all 0.7s ease;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button:hover label {
        color: @background;
        transition: all 0.7s ease;
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
