{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
let
  themes = import ../themes { inherit config pkgs theme; };
  binds = config.wayland.windowManager.hyprland.settings.bind;
  rawEntries = map (
    binding:
    let
      keys = builtins.elemAt binding._args 0;
      options = builtins.elemAt binding._args 2;
    in
    "${keys}  —  ${options.description}"
  ) binds;
  # Collapse only complete workspace sequences with matching descriptions.
  summarize =
    entry:
    let
      match = builtins.match "(SUPER \\+ (SHIFT \\+ |ALT \\+ )?)([1-9])(  —  Workspace: .*workspace )([1-9])(.*)" entry;
    in
    if match == null then
      entry
    else
      let
        prefix = builtins.elemAt match 0;
        key = builtins.elemAt match 2;
        description = builtins.elemAt match 3;
        workspace = builtins.elemAt match 4;
        suffix = builtins.elemAt match 5;
        complete = lib.all (
          i:
          builtins.elem "${prefix}${toString i}${description}${toString i}${suffix}" rawEntries
        ) (lib.range 1 9);
      in
      if key == workspace && complete then
        "${prefix}1–9${description}1–9${suffix}"
      else
        entry;
  entries = lib.unique (map summarize rawEntries);
  bindingsFile = pkgs.writeText "keybinds.txt" (lib.concatStringsSep "\n" entries + "\n");

  keybinds = pkgs.writeShellApplication {
    name = "keybinds";
    runtimeInputs = with pkgs; [
      rofi
    ];
    text = ''
      show_menu() {
        local status=0
        rofi -dmenu -i -no-custom -p "Keybinds" \
          -theme "${themes.listMenu}" \
          -theme-str 'window { width: 900px; } entry { placeholder: "Search keybinds..."; }' \
          < "${bindingsFile}" > /dev/null || status=$?
        [[ "$status" -eq 1 ]] && return 0
        return "$status"
      }

      main() {
        if (( $# > 1 )); then
          printf 'Expected at most one option.\n' >&2
          return 1
        fi

        case "''${1:-}" in
          "") show_menu ;;
          -h|--help) printf 'Usage: %s [-h|--help]\n' "''${0##*/}" ;;
          *) printf 'Unknown option: %s\n' "$1" >&2; return 1 ;;
        esac
      }

      main "$@"
    '';
  };
in
{
  home.packages = [
    keybinds
  ];
}
