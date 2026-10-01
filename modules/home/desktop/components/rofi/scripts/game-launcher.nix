{
  config,
  pkgs,
  theme,
  ...
}:
let
  themes = import ../themes { inherit config pkgs theme; };

  gameLauncher = pkgs.writeShellApplication {
    name = "game-launcher";
    runtimeInputs = with pkgs; [
      rofi
      xdg-utils
    ];
    text = ''
      exec rofi \
        -modi games \
        -show games \
        -plugin-path "${pkgs.rofi-games}/lib/rofi" \
        -theme "${themes.gameLauncher}" \
        -no-sort \
        "$@"
    '';
  };
in
{
  home.packages = [
    gameLauncher
  ];
}
