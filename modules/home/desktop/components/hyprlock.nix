{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
let
  colors = lib.mapAttrs (_: theme.toRgb) theme.colors;
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };
      background = [
        {
          monitor = "";
          path = "${config.xdg.cacheHome}/wallpapers/lockscreen";
          color = colors.background;
          blur_size = theme.blur.size;
          blur_passes = theme.blur.passes;
          brightness = 0.6;
        }
      ];
      label = [
        {
          monitor = "";
          text = "cmd[update:1000] ${pkgs.coreutils}/bin/date '+%A, %B %d'";
          position = "0, 405";
          halign = "center";
          valign = "center";
          font_family = "${theme.fonts.monospace.proportional} Bold";
          font_size = 30;
          color = colors.foreground;
        }
        {
          monitor = "";
          text = "cmd[update:1000] ${pkgs.coreutils}/bin/date '+%k:%M'";
          position = "0, 310";
          halign = "center";
          valign = "center";
          font_family = "${theme.fonts.monospace.proportional} Bold";
          font_size = 100;
          color = colors.muted;
        }
      ];
      input-field = [
        {
          monitor = "";
          size = "200, 30";
          position = "0, -468";
          halign = "center";
          valign = "center";
          fade_on_empty = true;
          font_family = theme.fonts.monospace.proportional;
          font_color = colors.foreground;
          placeholder_text = " Enter Password";
          outline_thickness = 2;
          inner_color = "rgba(255, 255, 255, 0.1)";
          outer_color = "rgba(0, 0, 0, 0)";
          check_color = colors.purple;
          capslock_color = colors.orange;
          numlock_color = colors.yellow;
          bothlock_color = colors.magenta;
          fail_color = colors.red;
          fail_text = "$FAIL <b>($ATTEMPTS)</b>";
          dots_size = 0.25;
          dots_spacing = 0.55;
          dots_center = true;
          dots_rounding = -1;
          hide_input = false;
        }
      ];
    };
  };
}
