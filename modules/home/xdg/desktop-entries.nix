{ config, lib, pkgs, ... }:

let
  hiddenEntries = {
    btop = pkgs.btop;
    kvantummanager = pkgs.kdePackages.qtstyleplugin-kvantum;
    mpv = pkgs.mpv;
    qt5ct = pkgs.libsForQt5.qt5ct;
    qt6ct = pkgs.kdePackages.qt6ct;
    thunar-bulk-rename = pkgs.thunar;
    thunar-settings = pkgs.thunar;
    thunar-volman-settings = pkgs.thunar-volman;
    uuctl = pkgs.uwsm;
    vicinae = pkgs.vicinae;
    xarchiver = pkgs.xarchiver;
  };

  namedEntries = {
    nvim = {
      package = pkgs.neovim;
      name = "Neovim";
    };
    zen-beta = {
      package = config.programs.zen-browser.package;
      name = "Zen Browser";
    };
    kitty = {
      package = pkgs.kitty;
      name = "Kitty";
    };
    "com.heroicgameslauncher.hgl" = {
      package = pkgs.heroic;
      name = "Heroic Games";
    };
    thunar = {
      package = pkgs.thunar;
      name = "Thunar";
    };
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

  renameDesktopEntry = name: entry: {
    name = "applications/${name}.desktop";
    value.source = editDesktopFile name entry.package [ "--set-name=${entry.name}" ];
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
    dataFile =
      (lib.mapAttrs' hideDesktopEntry hiddenEntries)
      // (lib.mapAttrs' renameDesktopEntry namedEntries);
  };
}
