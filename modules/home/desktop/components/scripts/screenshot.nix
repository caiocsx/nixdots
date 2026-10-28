{
  config,
  pkgs,
  ...
}:
let
  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.grim
      pkgs.hyprland
      pkgs.jq
      pkgs.slurp
      pkgs.wl-clipboard
    ];
    text = ''
      select_region() {
        slurp
      }

      select_window() {
        local monitors clients rectangles

        monitors="$(hyprctl monitors -j)"
        clients="$(hyprctl clients -j)"

        rectangles="$(jq -r --argjson monitors "$monitors" '
          [$monitors[] | .activeWorkspace.id, .specialWorkspace.id] as $visible
          | .[]
          | select(.mapped and (.hidden | not))
          | select(.workspace.id as $id | $visible | index($id))
          | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"
        ' <<< "$clients")"

        [[ -n "$rectangles" ]] || return 1
        slurp -r <<< "$rectangles"
      }

      select_output() {
        slurp -o -r
      }

      main() {
        local mode geometry output_directory output_file

        if (( $# > 1 )); then
          printf 'Expected at most one screenshot mode.\n' >&2
          return 2
        fi

        case "''${1:---region}" in
          -r|--region)
            mode="region"
            ;;
          -w|--window)
            mode="window"
            ;;
          -o|--output)
            mode="output"
            ;;
          *)
            printf 'Unknown screenshot mode: %s\n' "$1" >&2
            return 2
            ;;
        esac

        case "$mode" in
          region)
            geometry="$(select_region)" || return 0
            ;;
          window)
            geometry="$(select_window)" || return 0
            ;;
          output)
            geometry="$(select_output)" || return 0
            ;;
        esac

        [[ -n "$geometry" ]] || return 0

        output_directory="${config.xdg.userDirs.extraConfig.SCREENSHOTS}"
        mkdir -p -- "$output_directory"
        output_file="$output_directory/$(date +%Y-%m-%d_%H-%M-%S).png"
        grim -g "$geometry" "$output_file"
        wl-copy --type image/png < "$output_file"
      }

      main "$@"
    '';
  };
in
{
  home.packages = [ screenshot ];
}
