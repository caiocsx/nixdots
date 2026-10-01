{
  config,
  pkgs,
  theme,
  ...
}:
let
  themes = import ../themes { inherit config pkgs theme; };

  powerMenu = pkgs.writeShellApplication {
    name = "power-menu";
    runtimeInputs = with pkgs; [
      rofi
      util-linux
      procps
      coreutils
      hostname
      systemd
      gawk
      hyprshutdown
      hyprlock
    ];
    text = ''
      readonly ICON_YES=''
      readonly ICON_NO='󰅙'

      confirm_action() {
        local selected
        selected=$(printf '%s\n' "$ICON_YES" "$ICON_NO" |
          rofi -dmenu -no-custom -p "Confirmation" -mesg "Are you sure?" \
            -theme "${themes.confirm}") || return 1
        [[ "$selected" == "$ICON_YES" ]]
      }

      main() {
        local host user uptime_text last_login selected
        local icons=('' '' '󰍃' '󰌾' '󰏤' '󰤄')

        host=$(hostname)
        user=$(whoami)
        uptime_text=$(uptime -p)
        last_login=$(last -n 1 "$user" 2>/dev/null | awk -v user="$user" '$1 == user { print $4, $5, $6 }' || true)

        selected=$(printf '%s\n' "''${icons[@]}" |
          rofi -dmenu -no-custom -format i -p " $user@$host" \
            -mesg " Last Login: ''${last_login:-Unknown} |  Uptime: ''${uptime_text#up }" \
            -theme "${themes.powerMenu}") || return 0

        [[ "$selected" =~ ^[0-5]$ ]] || return 0
        if [[ "$selected" != 3 ]]; then
          confirm_action || return 0
        fi

        case "$selected" in
          0) exec hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0' ;;
          1) exec hyprshutdown -t 'Restarting...' --post-cmd reboot ;;
          2) exec hyprshutdown ;;
          3) pidof hyprlock || exec hyprlock ;;
          4) exec systemctl suspend ;;
          5) exec systemctl hibernate ;;
        esac
      }

      main "$@"
    '';
  };
in
{
  home.packages = [
    powerMenu
  ];
}
