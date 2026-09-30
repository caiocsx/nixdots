{ ... }:
let
  mkHiddenDesktopEntry =
    {
      name,
      exec ? "true",
    }:
    {
      text = ''
        [Desktop Entry]
        Type=Application
        Name=${name}
        Exec=${exec}
        NoDisplay=true
      '';
    };
in
{
  xdg = {
    dataFile = {
      "applications/uuctl.desktop" = mkHiddenDesktopEntry {
        name = "uuctl";
        exec = "uuctl";
      };
      "applications/thunar-settings.desktop" = mkHiddenDesktopEntry {
        name = "Thunar Settings";
      };
      "applications/thunar-bulk-rename.desktop" = mkHiddenDesktopEntry {
        name = "Thunar Bulk Rename";
      };
      "applications/thunar-volman-settings.desktop" = mkHiddenDesktopEntry {
        name = "Thunar Volman Settings";
      };
      "applications/qt5ct.desktop" = mkHiddenDesktopEntry {
        name = "Qt5 Configuration";
      };
      "applications/qt6ct.desktop" = mkHiddenDesktopEntry {
        name = "Qt6 Configuration";
      };
      "applications/kvantummanager.desktop" = mkHiddenDesktopEntry {
        name = "Kvantum Manager";
      };
      "applications/mpv.desktop" = mkHiddenDesktopEntry {
        name = "mpv";
        exec = "mpv %U";
      };
      "applications/rofi.desktop" = mkHiddenDesktopEntry {
        name = "Rofi";
      };
      "applications/rofi-theme-selector.desktop" = mkHiddenDesktopEntry {
        name = "Rofi Theme Selector";
      };
    };
  };
}
