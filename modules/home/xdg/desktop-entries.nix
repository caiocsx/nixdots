{ lib, pkgs, ... }:

let
  hiddenEntries = {
    btop = pkgs.btop;
    kitty = pkgs.kitty;
    nvim = pkgs.neovim;
    uuctl = pkgs.uwsm;
    mpv = pkgs.mpv;
    "org.gnome.FileRoller" = pkgs.file-roller;
    kvantummanager = pkgs.kdePackages.qtstyleplugin-kvantum;
    qt5ct = pkgs.libsForQt5.qt5ct;
    qt6ct = pkgs.kdePackages.qt6ct;
    rofi = pkgs.rofi;
    rofi-theme-selector = pkgs.rofi;
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
    dataFile = lib.mapAttrs' hideDesktopEntry hiddenEntries // {
      # Keep Steam visible when Rofi excludes the Game category.
      "applications/steam.desktop".source = editDesktopFile "steam" pkgs.steam [
        "--remove-category=Game"
      ];
    };
  };
}
