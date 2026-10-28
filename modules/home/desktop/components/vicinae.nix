{
  inputs,
  lib,
  pkgs,
  theme,
  ...
}:
{
  programs.vicinae = {
    enable = true;
    mutableSettings = true;
    systemd.enable = true;
    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      awww-switcher
      hypr-keybinds
    ];
    settings = {
      theme.dark.icon_theme = theme.icons.name;
      launcher_window.rounding = theme.borders.radius;
      font.rendering = "native";
      core.entrypoints = {
        manage-fallback.enabled = false;
        open-default-config.enabled = false;
        reload-scripts.enabled = false;
        report-bug.enabled = false;
        search-tray.enabled = false;
        sponsor.enabled = false;
      };
      tray.enabled = false;
      developer.enabled = false;
      media.enabled = false;
      system.enabled = false;
      theme.enabled = false;
      wm.enabled = false;
      launcher_window = {
        opacity = lib.mkForce theme.opacity.shell;
        material = "blur";
      };
      applications = {
        preferences = {
          defaultAction = "launch";
          launchPrefix = "uwsm app --";
        };
        entrypoints = {
          cups.enabled = false;
          vicinae.enabled = false;
        };
      };
      providers = {
        "@sovereign/vicinae-extension-awww-switcher-0" = {
          preferences = {
            wallpaperPath = "~/Pictures/Wallpapers";
            transitionType = "any";
            transitionDuration = "2";
            showImageDetails = false;
            postCommand = ''update-lockscreen-wallpaper "''${wallpaper}"'';
          };
        };
      };
    };
  };
}
