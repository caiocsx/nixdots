{
  config,
  lib,
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
      pkgs.swappy
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

        rectangles="$(
          jq -r --argjson monitors "$monitors" '
            [$monitors[] | .activeWorkspace.id, .specialWorkspace.id] as $visible
            | .[]
            | select(.mapped and (.hidden | not))
            | select(.workspace.id as $id | $visible | index($id))
            | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"
          ' <<< "$clients"
        )"

        [[ -n "$rectangles" ]] || return 1

        slurp -r <<< "$rectangles"
      }

      select_output() {
        slurp -o -r
      }

      main() {
        local mode="region"
        local geometry file
        local directory=${lib.escapeShellArg config.xdg.userDirs.extraConfig.SCREENSHOTS}
        local copy=false

        while (( $# > 0 )); do
          case "$1" in
            -r|--region)
              mode="region"
              ;;
            -w|--window)
              mode="window"
              ;;
            -o|--output)
              mode="output"
              ;;
            -c|--copy)
              copy=true
              ;;
            -h|--help)
              echo "Usage: ''${0##*/} [-r|--region | -w|--window | -o|--output] [-c|--copy] [-h|--help]"
              return 0
              ;;
            *)
              printf 'Unknown option: %s\n' "$1" >&2
              return 1
              ;;
          esac

          shift
        done

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

        mkdir -p -- "$directory"
        file="$directory/$(date +%Y-%m-%d_%H-%M-%S_%N).png"
        grim -g "$geometry" "$file"

        if "$copy"; then
          wl-copy --type image/png < "$file"
        else
          swappy -f "$file" -o "$file"
        fi
      }

      main "$@"
    '';
  };
in
{
  home.packages = [ screenshot ];
}
