{ ... }:
{
  imports = [
    ./desktop
    ./theme
    ./xdg
    ./programs
    ./session.nix
  ];

  home = {
    username = "caiocsx";
    homeDirectory = "/home/caiocsx";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
