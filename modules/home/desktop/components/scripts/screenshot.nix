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
        local mode="region" mode_set="" delay="0" geometry output_directory output_file

        while (( $# > 0 )); do
          case "$1" in
            -r|--region)
              [[ -z "$mode_set" ]] || { printf 'Expected at most one screenshot mode.\n' >&2; return 2; }
              mode="region"
              mode_set=1
              ;;
            -w|--window)
              [[ -z "$mode_set" ]] || { printf 'Expected at most one screenshot mode.\n' >&2; return 2; }
              mode="window"
              mode_set=1
              ;;
            -o|--output)
              [[ -z "$mode_set" ]] || { printf 'Expected at most one screenshot mode.\n' >&2; return 2; }
              mode="output"
              mode_set=1
              ;;
            -d|--delay)
              if (( $# < 2 )) || [[ ! "$2" =~ ^[0-9]+$ ]]; then
                printf 'Delay must be a non-negative number of seconds.\n' >&2
                return 2
              fi
              delay="$2"
              shift
              ;;
            *)
              printf 'Unknown screenshot option: %s\n' "$1" >&2
              return 2
              ;;
          esac
          shift
        done

        sleep "$delay"

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
