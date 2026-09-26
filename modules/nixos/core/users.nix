{ pkgs, ... }:
{
  users = {
    defaultUserShell = pkgs.zsh;
    users.caiocsx = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
      ];
    };
  };
}
