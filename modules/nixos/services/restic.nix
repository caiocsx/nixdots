{ pkgs, ... }:
{
  services.restic.backups.home = {
    repository = "/var/lib/restic/caiocsx";
    passwordFile = "/etc/restic/caiocsx-password";
    initialize = true;
    paths = [
      "/home/caiocsx/Documents"
      "/home/caiocsx/nixdots"
      "/home/caiocsx/Pictures"
      "/home/caiocsx/Projects"
      "/home/caiocsx/Videos"
    ];
    exclude = [
      "/home/caiocsx/Projects/**/node_modules"
      "/home/caiocsx/Projects/**/target"
      "/home/caiocsx/Projects/**/.direnv"
      "/home/caiocsx/nixdots/result"
    ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 3"
    ];
  };

  environment.systemPackages = with pkgs; [ restic ];
}
