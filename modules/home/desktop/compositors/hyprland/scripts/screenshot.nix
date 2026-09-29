{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "screenshot";
      runtimeInputs = with pkgs; [
        grim
        hyprland
        jq
        slurp
        swappy
        wl-clipboard
      ];
      text = ''
        main() {
          local mode=region geometry monitors clients rectangles
          local copy=false arg

          for arg in "$@"; do
            case "$arg" in
              -r|--region) mode=region ;;
              -w|--window) mode=window ;;
              -o|--output) mode=output ;;
              -c|--copy) copy=true ;;
              -h|--help)
                echo "Usage: screenshot [-r|--region | -w|--window | -o|--output] [-c|--copy]"
                echo "Select a region (default), window or output, then edit in Swappy."
                echo "--copy copies the capture instead of opening the editor."
                return 0
                ;;
              *) printf 'Unknown option: %s\n' "$arg" >&2; return 1 ;;
            esac
          done

          case "$mode" in
            region) geometry=$(slurp) || return 0 ;;
            output) geometry=$(slurp -o) || return 0 ;;
            window)
              monitors=$(hyprctl monitors -j)
              clients=$(hyprctl clients -j)
              rectangles=$(jq -r --argjson monitors "$monitors" '
                [$monitors[] | .activeWorkspace.id, .specialWorkspace.id] as $visible
                | .[]
                | select(.mapped and (.hidden | not))
                | select(.workspace.id as $id | $visible | index($id))
                | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"
              ' <<< "$clients")
              [[ -n "$rectangles" ]] || return 0
              geometry=$(slurp -r <<< "$rectangles") || return 0
              ;;
          esac

          [[ -n "$geometry" ]] || return 0

          if "$copy"; then
            grim -g "$geometry" - | wl-copy --type image/png
          else
            grim -g "$geometry" - | swappy -f -
          fi
        }

        main "$@"
      '';
    })
  ];
}
