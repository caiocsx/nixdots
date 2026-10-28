{
  config,
  pkgs,
  ...
}:
let
  updateLockscreenWallpaper = pkgs.writeShellApplication {
    name = "update-lockscreen-wallpaper";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.imagemagick
    ];
    text = ''
      temporary=""

      cleanup() {
        [[ -z "$temporary" ]] || rm -f -- "$temporary"
      }

      main() {
        local wallpaper cache_directory destination

        if [[ $# -ne 1 ]]; then
          printf 'Expected one wallpaper path.\n' >&2
          return 2
        fi

        wallpaper="$(realpath -e -- "$1")"
        if [[ ! -f "$wallpaper" || ! -r "$wallpaper" ]]; then
          printf 'Wallpaper is not a readable regular file: %s\n' "$wallpaper" >&2
          return 1
        fi

        cache_directory="${config.xdg.cacheHome}/wallpapers"
        destination="$cache_directory/lockscreen"

        mkdir -p -- "$cache_directory"
        temporary="$(mktemp --tmpdir="$cache_directory" '.lockscreen.XXXXXXXX')"

        case "''${wallpaper,,}" in
          *.gif)
            rm -f -- "$temporary"
            magick "''${wallpaper}[0]" -auto-orient -strip "PNG:$temporary"
            ;;
          *)
            rm -f -- "$temporary"
            ln -s -- "$wallpaper" "$temporary"
            ;;
        esac

        mv -fT -- "$temporary" "$destination"
        temporary=""
      }

      trap cleanup EXIT
      main "$@"
    '';
  };
in
{
  home.packages = [ updateLockscreenWallpaper ];
}
