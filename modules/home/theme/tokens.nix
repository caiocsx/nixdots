{
  config,
  lib,
  pkgs,
  ...
}:
let
  stylixFonts = config.stylix.fonts;
  stylixColors = config.lib.stylix.colors.withHashtag;
  palette = {
    background = stylixColors.base00;
    surface = stylixColors.base01;
    foreground = stylixColors.base05;
    muted = stylixColors.base04;
    cyan = stylixColors.base0C;
    blue = stylixColors.base0D;
    green = stylixColors.base0B;
    magenta = stylixColors.base0F;
    orange = stylixColors.base09;
    purple = stylixColors.base0E;
    red = stylixColors.base08;
    yellow = stylixColors.base0A;
  };
  accentColor = palette.blue;
  gtkCss = pkgs.writeText "theme-gtk.css" ''
    @define-color background ${palette.background};
    @define-color surface ${palette.surface};
    @define-color foreground ${palette.foreground};
    @define-color muted ${palette.muted};

    @define-color accent ${accentColor};
    @define-color red ${palette.red};
    @define-color orange ${palette.orange};
    @define-color yellow ${palette.yellow};
    @define-color green ${palette.green};
    @define-color cyan ${palette.cyan};
    @define-color blue ${palette.blue};
    @define-color magenta ${palette.magenta};
    @define-color purple ${palette.purple};
  '';
  opacityToHex =
    opacity:
    let
      hex = lib.toHexString (builtins.floor (opacity * 255));
    in
    if builtins.stringLength hex == 1 then "0${hex}" else hex;

  withAlpha = color: opacity: "#${lib.removePrefix "#" color}${opacityToHex opacity}";
  toRgb = color: "rgb(${lib.removePrefix "#" color})";
in
{
  inherit withAlpha toRgb;

  colors = palette // {
    accent = accentColor;
  };
  css.gtk = gtkCss;
  fonts = {
    interface = stylixFonts.sansSerif.name;
    monospace = {
      regular = stylixFonts.monospace.name;
      proportional = "${stylixFonts.monospace.name} Propo";
    };
  };
  icons = {
    inherit (config.gtk.iconTheme) name package;
  };
  borders = {
    radius = 8;
    width = 0;
  };
  gaps = {
    inner = 3;
    outer = 10;
  };
  opacity = {
    activeWindow = 1;
    inactiveWindow = 0.9;
    popup = 0.9;
  };
  blur = {
    size = 6;
    passes = 3;
  };
}
