{
  config,
  pkgs,
  theme,
  ...
}:
let
  themes = import ../themes { inherit config pkgs theme; };

  launcher = pkgs.writeShellApplication {
    name = "launcher";
    runtimeInputs = with pkgs; [
      rofi
      uwsm
    ];
    text = ''
      exec rofi -show drun -run-command "uwsm app -- {cmd}" -theme "${themes.launcher}"
    '';
  };
in
{
  home.packages = [
    launcher
  ];
}
