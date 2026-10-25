{ lib, pkgs, ... }:

let
  hiddenEntries = {
    uuctl = pkgs.uwsm;
    mpv = pkgs.mpv;
    xarchiver = pkgs.xarchiver;
    kvantummanager = pkgs.kdePackages.qtstyleplugin-kvantum;
    qt5ct = pkgs.libsForQt5.qt5ct;
    qt6ct = pkgs.kdePackages.qt6ct;
    thunar-bulk-rename = pkgs.thunar;
    thunar-settings = pkgs.thunar;
    thunar-volman-settings = pkgs.thunar-volman;
  };

  editDesktopFile =
    name: package: args:
    pkgs.runCommandLocal "${name}.desktop"
      {
        nativeBuildInputs = [ pkgs.desktop-file-utils ];
      }
      ''
        install -m644 \
          ${package}/share/applications/${name}.desktop \
          "$out"

        desktop-file-edit \
          ${lib.escapeShellArgs args} \
          "$out"
      '';

  hideDesktopEntry = name: package: {
    name = "applications/${name}.desktop";
    value.source = editDesktopFile name package [
      "--set-key=NoDisplay"
      "--set-value=true"
    ];
  };
in
{
  xdg = {
    desktopEntries.vesktop = {
      name = "Discord";
      genericName = "Internet Messenger";
      comment = "Voice and text chat";
      exec = "vesktop %U";
      icon = "discord";
      terminal = false;
      categories = [
        "Network"
        "InstantMessaging"
      ];
      mimeType = [
        "x-scheme-handler/discord"
      ];
      settings.Keywords = "Discord;Vesktop;Chat;";
    };
    dataFile = lib.mapAttrs' hideDesktopEntry hiddenEntries;
  };
}
