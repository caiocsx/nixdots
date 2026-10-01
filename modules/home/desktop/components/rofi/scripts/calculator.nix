{
  config,
  pkgs,
  theme,
  ...
}:
let
  themes = import ../themes { inherit config pkgs theme; };

  qalcFiltered = pkgs.writeShellApplication {
    name = "qalc-filtered";
    runtimeInputs = with pkgs; [
      libqalculate
      gnused
    ];
    text = ''
      qalc "$@" | sed '/^warning: Unknown variables/d'
    '';
  };

  calculator = pkgs.writeShellApplication {
    name = "calculator";
    runtimeInputs = with pkgs; [
      rofi
      rofi-calc
      gnused
      wl-clipboard
    ];
    text = ''
      exec rofi \
        -show calc \
        -modi calc \
        -plugin-path "${pkgs.rofi-calc}/lib/rofi" \
        -qalc-binary "${qalcFiltered}/bin/qalc-filtered" \
        -theme "${themes.calculator}" \
        -no-show-match \
        -no-sort \
        -calc-command "printf '%s' '{result}' | sed 's/.*= //' | wl-copy" \
        -calc-command-history \
        "$@"
    '';
  };
in
{
  home.packages = [
    calculator
  ];
}
