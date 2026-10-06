{ config, ... }:
{
  xdg.configFile."xfce4/helpers.rc".text = ''
    TerminalEmulator=${config.home.sessionVariables.TERMINAL}
  '';
}
