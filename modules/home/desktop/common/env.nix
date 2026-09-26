{ ... }:
{
  xdg.configFile."uwsm/env".text = ''
    export NIXOS_OZONE_WL=1
  '';
}
