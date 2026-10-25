{ config, ... }:
{
  imports = [
    ./desktop-entries.nix
    ./mime-apps.nix
    ./user-dirs.nix
  ];

  xdg = {
    enable = true;
    configFile = {
      "xfce4/helpers.rc".text = ''
        TerminalEmulator=${config.home.sessionVariables.TERMINAL}
      '';
      "xarchiver/xarchiverrc".text = ''
        [xarchiver]
        preferred_extract_dir=
      '';
    };
  };
}
