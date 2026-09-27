{ theme, ... }:
{
  wayland.windowManager.hyprland.settings.config = {
    general = {
      border_size = theme.borders.width;
      gaps_in = theme.gaps.inner;
      gaps_out = theme.gaps.outer;
      "col.active_border" = theme.colors.accent;
      "col.inactive_border" = theme.colors.surface;
      layout = "dwindle";
    };
    dwindle = {
      preserve_split = true;
      force_split = 2;
    };
    decoration = {
      rounding = theme.borders.radius;
      active_opacity = theme.opacity.activeWindow;
      inactive_opacity = theme.opacity.inactiveWindow;
      blur = {
        enabled = true;
        size = theme.blur.size;
        passes = theme.blur.passes;
        popups = true;
        input_methods = true;
      };
    };
    cursor = {
      hide_on_key_press = true;
      inactive_timeout = 10;
      no_warps = true;
      enable_hyprcursor = true;
    };
    input = {
      follow_mouse = 2;
      sensitivity = 0;
      force_no_accel = true;
    };
    ecosystem = {
      no_donation_nag = true;
      no_update_news = true;
    };
    xwayland = {
      force_zero_scaling = true;
    };
    misc = {
      font_family = theme.fonts.monospace.proportional;
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      focus_on_activate = true;
      close_special_on_empty = true;
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
    };
  };
}
