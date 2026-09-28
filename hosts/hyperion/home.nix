{ pkgs, ... }:
{
  imports = [
    ../../modules/home/desktop/shells/modular
  ];

  home.packages = with pkgs; [
    brightnessctl
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      {
        output = "eDP-1";
        mode = "1920x1080@60";
        position = "0x0";
        scale = "1.0";
      }
    ];
    config.input = {
      kb_layout = "br";
      kb_variant = "";
      touchpad = {
        natural_scroll = false;
        disable_while_typing = true;
      };
    };
  };
}
