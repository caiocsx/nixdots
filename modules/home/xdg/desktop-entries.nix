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
      "applications/mpv.desktop" = mkHiddenDesktopEntry {
        name = "mpv";
        exec = "mpv %U";
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
      "applications/rofi.desktop" = mkHiddenDesktopEntry {
        name = "Rofi";
      };
      "applications/rofi-theme-selector.desktop" = mkHiddenDesktopEntry {
        name = "Rofi Theme Selector";
      };
    };
  };
}
