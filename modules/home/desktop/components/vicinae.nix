{
  inputs,
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
      nix
      process-manager
    ];
    settings = {
      applications = {
        preferences = {
          defaultAction = "focus";
          launchPrefix = "uwsm app --";
        };
        entrypoints = {
          cups.enabled = false;
          vicinae.enabled = false;
        };
      };
      tray.enabled = false;
      core.entrypoints = {
        manage-fallback.enabled = false;
        open-default-config.enabled = false;
        reload-scripts.enabled = false;
        report-bug.enabled = false;
        search-tray.enabled = false;
        sponsor.enabled = false;
      };
      developer.enabled = false;
      media.enabled = false;
      system.enabled = false;
      theme.enabled = false;
      wm.enabled = false;
      font.rendering = "native";
      launcher_window.rounding = theme.borders.radius;
      theme.dark.icon_theme = theme.icons.name;
      providers = {
        "@knoopx/vicinae-extension-nix-0" = {
          entrypoints = {
            flake-packages.enabled = false;
            pull-requests.enabled = false;
          };
        };
        "@sovereign/vicinae-extension-awww-switcher-0" = {
          preferences = {
            wallpaperPath = "~/Pictures/Wallpapers";
            transitionType = "any";
            transitionDuration = "2";
            showImageDetails = false;
          };
        };
      };
    };
  };
}
