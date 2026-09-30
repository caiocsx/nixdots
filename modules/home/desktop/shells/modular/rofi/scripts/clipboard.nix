{
  config,
  pkgs,
  theme,
  ...
}:
let
  themes = import ../themes { inherit config pkgs theme; };

  clipboard = pkgs.writeShellApplication {
    name = "clipboard";
    runtimeInputs = with pkgs; [
      rofi
      wl-clipboard
      cliphist
      libnotify
    ];
    text = ''
      readonly ICON_YES=''
      readonly ICON_NO='󰅙'

      notify_info() {
        notify-send -t 3000 "Clipboard" "$1"
      }

      clear_history() {
        local selected
        selected=$(printf '%s\n' "$ICON_YES" "$ICON_NO" |
          rofi -dmenu -no-custom -mesg "Clear clipboard history?" \
            -theme "${themes.confirm}") || return 0
        [[ "$selected" == "$ICON_YES" ]] || return 0

        cliphist wipe
        notify_info "Clipboard history cleared."
      }

      show_menu() {
        local history selected
        local items=() labels=()
        history=$(cliphist list)
        if [[ -z "$history" ]]; then
          notify_info "Clipboard history is empty."
          return 0
        fi

        mapfile -t items <<< "$history"
        local item
        for item in "''${items[@]}"; do
          labels+=("''${item#*$'\t'}")
        done

        selected=$(printf '%s\n' "''${labels[@]}" |
          rofi -dmenu -no-custom -format i -p "Clipboard" \
            -theme "${themes.listMenu}") || return 0
        [[ "$selected" =~ ^[0-9]+$ ]] || return 0
        (( selected < ''${#items[@]} )) || return 1

        printf '%s\n' "''${items[selected]}" | cliphist decode | wl-copy
        notify_info "Copied to clipboard."
      }

      main() {
        if (( $# > 1 )); then
          printf 'Expected at most one option.\n' >&2
          return 1
        fi

        case "''${1:-}" in
          "") show_menu ;;
          -w|--wipe) clear_history ;;
          -h|--help) printf 'Usage: %s [-w|--wipe | -h|--help]\n' "''${0##*/}" ;;
          *) printf 'Unknown option: %s\n' "$1" >&2; return 1 ;;
        esac
      }

      main "$@"
    '';
  };
in
{
  home.packages = [
    clipboard
  ];
}
