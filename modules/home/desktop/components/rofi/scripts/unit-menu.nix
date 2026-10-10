{
  config,
  pkgs,
  theme,
  ...
}:
let
  themes = import ../themes { inherit config pkgs theme; };

  unitMenu = pkgs.writeShellApplication {
    name = "unit-menu";
    runtimeInputs = with pkgs; [
      rofi
      uwsm
    ];
    text = ''
      exec uuctl "$@" rofi -dmenu -i -no-custom \
        -theme "${themes.listMenu}" -p
    '';
  };
in
{
  home.packages = [
    unitMenu
  ];
}
