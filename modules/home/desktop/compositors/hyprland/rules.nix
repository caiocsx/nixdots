{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    window_rule = [
      {
        name = "suppress-maximize";
        match = {
          class = ".*";
        };
        suppress_event = "maximize";
      }
      {
        name = "fix-xwayland-drags";
        match = {
          class = "^$";
          title = "^$";
          xwayland = true;
          float = true;
          fullscreen = false;
          pin = false;
        };
        no_focus = true;
      }
      {
        name = "float-system-tools";
        match = {
          class = "^(xdg-desktop-portal-gtk|org.gnome.FileRoller|qalculate-gtk)$";
        };
        float = true;
      }
      {
        name = "float-file-dialogs";
        match = {
          title = "^(Open File|Select a File|Open Folder|Save As|Library|File Upload|File Operation Progress|Confirm to replace files|Rename).*";
        };
        float = true;
        stay_focused = true;
      }
      {
        name = "float-steam-popups";
        match = {
          class = "^[Ss]team$";
          title = "^Friends List$";
        };
        float = true;
        center = true;
        size = "380 720";
      }
      {
        name = "size-browser-dialogs";
        match = {
          class = "^(firefox|google-chrome|zen|zen-beta)$";
          title = "^(Save As|Choose Files|Open File|Open Folder)$";
        };
        size = "800 600";
        stay_focused = true;
      }
      {
        name = "pip-browser";
        match = {
          class = "^(firefox|google-chrome|zen|zen-beta)$";
          title = ".*(Picture-in-Picture|Picture in Picture).*";
        };
        float = true;
        pin = true;
        size = "480 270";
        move = "74.5% 4.25%";
        animation = "slide";
      }
    ];
  };
}
