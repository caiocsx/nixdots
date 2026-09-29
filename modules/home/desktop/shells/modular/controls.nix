{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "control-center-toggle";
      runtimeInputs = [ pkgs.swaynotificationcenter ];
      text = "exec swaync-client -t -sw";
    })
    (pkgs.writeShellApplication {
      name = "bar-toggle";
      runtimeInputs = [ pkgs.systemd ];
      text = ''
        if systemctl --user is-active --quiet waybar.service; then
          exec systemctl --user stop waybar.service
        else
          exec systemctl --user start waybar.service
        fi
      '';
    })
  ];
}
