{ lib, ... }:
{
  imports = [
    ../../modules/home/desktop/shells/modular
  ];

  xdg.configFile."uwsm/env".text = lib.mkAfter ''
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
  '';
}
