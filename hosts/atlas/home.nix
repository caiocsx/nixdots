{ lib, ... }:
{
  imports = [
    ../../modules/home/desktop/shells/modular
  ];

  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        {
          output = "HDMI-A-1";
          mode = "1920x1080@180";
          position = "0x0";
          scale = "1.0";
        }
      ];
      config.input = {
        kb_layout = "us";
        kb_variant = "intl";
      };
    };
  };

  xdg.configFile."uwsm/env".text = lib.mkAfter ''
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
  '';
}
