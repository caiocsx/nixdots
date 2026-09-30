{ config, pkgs, ... }:
let
  lockCommand = "${config.home.profileDirectory}/bin/session-lock";
in
{
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
