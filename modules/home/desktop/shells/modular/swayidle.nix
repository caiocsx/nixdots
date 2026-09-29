{ config, pkgs, ... }:
let
  sessionLock = pkgs.writeShellApplication {
    name = "session-lock";
    runtimeInputs = [ pkgs.procps ];
    text = ''
      if pgrep -u "$UID" -x hyprlock >/dev/null; then
        exit 0
      fi
      exec ${config.programs.hyprlock.package}/bin/hyprlock
    '';
  };
  lockCommand = "${sessionLock}/bin/session-lock";
in
{
  home.packages = [ sessionLock ];

  services.swayidle = {
    enable = true;
    extraArgs = [ "-w" ];
    events = {
      lock = lockCommand;
      before-sleep = lockCommand;
    };
    timeouts = [
      {
        timeout = 600;
        command = lockCommand;
      }
    ];
  };
}
