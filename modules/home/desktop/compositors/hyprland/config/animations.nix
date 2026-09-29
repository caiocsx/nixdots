{ lib, ... }:
let
  lua = lib.generators.mkLuaInline;
in
{
  wayland.windowManager.hyprland.settings = {
    curve = [
      {
        _args = [
          "smooth"
          {
            type = "bezier";
            points = lua "{ {0.25, 0.1}, {0.25, 1.0} }";
          }
        ];
      }
      {
        _args = [
          "balanced"
          {
            type = "bezier";
            points = lua "{ {0.2, 0.0}, {0.3, 1.0} }";
          }
        ];
      }
      {
        _args = [
          "crisp"
          {
            type = "bezier";
            points = lua "{ {0.3, 0.0}, {0.4, 1.0} }";
          }
        ];
      }
      {
        _args = [
          "flow"
          {
            type = "bezier";
            points = lua "{ {0.15, 0.0}, {0.35, 1.0} }";
          }
        ];
      }
    ];

    animation = [
      {
        leaf = "windows";
        enabled = true;
        speed = 4;
        bezier = "smooth";
      }
      {
        leaf = "windowsIn";
        enabled = true;
        speed = 3;
        bezier = "balanced";
        style = "slide";
      }
      {
        leaf = "windowsOut";
        enabled = true;
        speed = 2;
        bezier = "crisp";
        style = "slide";
      }
      {
        leaf = "windowsMove";
        enabled = true;
        speed = 3;
        bezier = "balanced";
      }
      {
        leaf = "workspaces";
        enabled = true;
        speed = 4;
        bezier = "flow";
        style = "slide";
      }
      {
        leaf = "workspacesIn";
        enabled = true;
        speed = 3;
        bezier = "flow";
        style = "slide";
      }
      {
        leaf = "workspacesOut";
        enabled = true;
        speed = 3;
        bezier = "flow";
        style = "slide";
      }
      {
        leaf = "specialWorkspace";
        enabled = true;
        speed = 4;
        bezier = "flow";
        style = "slidevert";
      }
      {
        leaf = "specialWorkspaceIn";
        enabled = true;
        speed = 3;
        bezier = "flow";
        style = "slidevert";
      }
      {
        leaf = "specialWorkspaceOut";
        enabled = true;
        speed = 3;
        bezier = "flow";
        style = "slidevert";
      }
      {
        leaf = "fadeIn";
        enabled = true;
        speed = 3;
        bezier = "balanced";
      }
      {
        leaf = "fadeOut";
        enabled = true;
        speed = 2;
        bezier = "crisp";
      }
      {
        leaf = "fadeSwitch";
        enabled = true;
        speed = 3;
        bezier = "balanced";
      }
      {
        leaf = "fadeShadow";
        enabled = true;
        speed = 3;
        bezier = "balanced";
      }
      {
        leaf = "fadeGlow";
        enabled = true;
        speed = 3;
        bezier = "balanced";
      }
      {
        leaf = "fadeDim";
        enabled = true;
        speed = 4;
        bezier = "smooth";
      }
      {
        leaf = "fadeLayersIn";
        enabled = true;
        speed = 3;
        bezier = "balanced";
      }
      {
        leaf = "fadeLayersOut";
        enabled = true;
        speed = 2;
        bezier = "crisp";
      }
      {
        leaf = "fadePopupsIn";
        enabled = true;
        speed = 3;
        bezier = "balanced";
      }
      {
        leaf = "fadePopupsOut";
        enabled = true;
        speed = 2;
        bezier = "crisp";
      }
      {
        leaf = "fadeDpms";
        enabled = true;
        speed = 4;
        bezier = "smooth";
      }
      {
        leaf = "border";
        enabled = true;
        speed = 4;
        bezier = "smooth";
      }
      {
        leaf = "layersIn";
        enabled = true;
        speed = 3;
        bezier = "balanced";
        style = "popin";
      }
      {
        leaf = "layersOut";
        enabled = true;
        speed = 2;
        bezier = "crisp";
        style = "popin";
      }
      {
        leaf = "zoomFactor";
        enabled = true;
        speed = 4;
        bezier = "smooth";
      }
      {
        leaf = "monitorAdded";
        enabled = true;
        speed = 4;
        bezier = "smooth";
      }
    ];
  };
}
