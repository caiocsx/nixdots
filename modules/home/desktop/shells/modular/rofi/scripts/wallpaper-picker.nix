{
  config,
  pkgs,
  theme,
  ...
}:

let
  themes = import ../themes { inherit config pkgs theme; };

  wallpaperPicker = pkgs.writeShellApplication {
    name = "wallpaper-picker";
    runtimeInputs = with pkgs; [
      rofi
      awww
      libnotify
      imagemagick
      coreutils
      findutils
    ];
    text = ''
      readonly WALLPAPERS_DIR="${config.home.homeDirectory}/Pictures/Wallpapers"
      readonly CACHE_DIR="${config.xdg.cacheHome}/wallpapers"
      readonly THUMB_DIR="$CACHE_DIR/thumbs"
      readonly CURRENT_WALLPAPER="$CACHE_DIR/current"
      readonly LOCKSCREEN_WALLPAPER="$CACHE_DIR/lockscreen"
      wallpapers=()
      temp_dir=""

      cleanup() {
        [[ -z "$temp_dir" ]] || rm -rf -- "$temp_dir"
      }
      trap cleanup EXIT

      notify_info() {
        notify-send -a "Wallpaper Picker" -t 3000 "$1" "''${2:-}"
      }

      init_wallpapers() {
        [[ -d "$WALLPAPERS_DIR" ]] || {
          notify_info "Directory not found" "$WALLPAPERS_DIR"
          return 1
        }
        temp_dir=$(mktemp -d)
        find -L "$WALLPAPERS_DIR" -type f \
          \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) \
          -print0 | sort -z > "$temp_dir/files"
        mapfile -d "" -t wallpapers < "$temp_dir/files"
        if (( ''${#wallpapers[@]} == 0 )); then
          notify_info "No wallpapers found" "$WALLPAPERS_DIR"
          return 1
        fi
      }

      image_key() {
        local checksum
        checksum=$(printf '%s' "$1" | sha256sum)
        printf '%s\n' "''${checksum%% *}"
      }

      thumbnail_path() {
        local key
        key=$(image_key "$1")
        printf '%s/%s.png\n' "$THUMB_DIR" "$key"
      }

      ensure_thumbnail() {
        local source="$1" target="$2"
        [[ -s "$target" && "$target" -nt "$source" ]] && return 0
        if ! magick "''${source}[0]" -auto-orient -thumbnail '512x512^' \
          -gravity center -extent 512x512 -strip "$target"; then
          rm -f -- "$target"
          return 1
        fi
      }

      set_wallpaper() {
        local source lockscreen key
        source=$(realpath -e -- "$1")
        [[ -f "$source" ]] || {
          notify_info "File not found" "$source"
          return 1
        }
        mkdir -p -- "$CACHE_DIR"
        lockscreen="$source"
        if [[ "''${source,,}" == *.gif ]]; then
          key=$(image_key "$source")
          lockscreen="$CACHE_DIR/lockscreen-$key.png"
          if [[ ! -s "$lockscreen" || "$source" -nt "$lockscreen" ]]; then
            if ! magick "''${source}[0]" -auto-orient -strip "$lockscreen"; then
              rm -f -- "$lockscreen"
              return 1
            fi
          fi
        fi

        awww img "$source" --transition-type any --transition-fps 60 --transition-duration 0.5
        ln -sfn -- "$source" "$CURRENT_WALLPAPER"
        ln -sfn -- "$lockscreen" "$LOCKSCREEN_WALLPAPER"
      }

      current_index() {
        local current i
        current=$(readlink -f -- "$CURRENT_WALLPAPER" || true)
        for i in "''${!wallpapers[@]}"; do
          if [[ "''${wallpapers[i]}" -ef "$current" ]]; then
            printf '%s\n' "$i"
            return 0
          fi
        done
        printf '%s\n' -1
      }

      cycle_wallpaper() {
        local direction="$1" index count
        init_wallpapers
        index=$(current_index)
        count=''${#wallpapers[@]}
        if (( index < 0 )); then
          index=0
        else
          index=$(( (index + direction + count) % count ))
        fi
        set_wallpaper "''${wallpapers[index]}"
      }

      random_wallpaper() {
        local current index count
        init_wallpapers
        current=$(current_index)
        count=''${#wallpapers[@]}
        # Pick from all other indices without an unbounded retry loop.
        if (( count > 1 && current >= 0 )); then
          index=$(shuf -i "0-$((count - 2))" -n 1)
          if (( index >= current )); then
            index=$((index + 1))
          fi
        else
          index=$(shuf -i "0-$((count - 1))" -n 1)
        fi
        set_wallpaper "''${wallpapers[index]}"
      }

      show_menu() {
        local wallpaper thumbnail selected label
        local jobs=0
        init_wallpapers
        mkdir -p -- "$THUMB_DIR"

        for wallpaper in "''${wallpapers[@]}"; do
          thumbnail=$(thumbnail_path "$wallpaper")
          [[ -s "$thumbnail" && "$thumbnail" -nt "$wallpaper" ]] && continue
          ensure_thumbnail "$wallpaper" "$thumbnail" &
          jobs=$((jobs + 1))
          if (( jobs == 4 )); then
            wait
            jobs=0
          fi
        done
        wait

        for wallpaper in "''${wallpapers[@]}"; do
          thumbnail=$(thumbnail_path "$wallpaper")
          [[ -s "$thumbnail" ]] || thumbnail=""
          label="''${wallpaper##*/}"
          label="''${label//$'\n'/ }"
          label="''${label//$'\r'/ }"
          printf '%s\0icon\x1f%s\n' "$label" "$thumbnail"
        done > "$temp_dir/menu"

        selected=$(rofi -dmenu -no-custom -format i -i \
          -theme "${themes.wallpaperPicker}" < "$temp_dir/menu") || return 0
        [[ "$selected" =~ ^[0-9]+$ ]] || return 0
        (( selected < ''${#wallpapers[@]} )) || return 1
        set_wallpaper "''${wallpapers[selected]}"
      }

      main() {
        local expected=1
        [[ "''${1:-}" == -s || "''${1:-}" == --set ]] && expected=2
        if (( $# > expected )); then
          printf 'Too many arguments.\n' >&2
          return 1
        fi

        case "''${1:-}" in
          "") show_menu ;;
          -n|--next) cycle_wallpaper 1 ;;
          -p|--prev) cycle_wallpaper -1 ;;
          -r|--random) random_wallpaper ;;
          -s|--set)
            if (( $# != 2 )); then
              printf 'Please provide a wallpaper file path.\n' >&2
              return 1
            fi
            set_wallpaper "$2"
            ;;
          -c|--current) readlink -f -- "$CURRENT_WALLPAPER" ;;
          -h|--help)
            printf 'Usage: %s [-n|--next | -p|--prev | -r|--random | -s|--set FILE | -c|--current | -h|--help]\n' "''${0##*/}"
            ;;
          *) printf 'Unknown option: %s\n' "$1" >&2; return 1 ;;
        esac
      }

      main "$@"
    '';
  };
in
{
  home.packages = [
    wallpaperPicker
  ];
}
