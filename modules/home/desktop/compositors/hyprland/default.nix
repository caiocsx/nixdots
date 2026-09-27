{ pkgs, ... }:
{
  imports = [
    ../../common
    ./animations.nix
    ./binds.nix
    ./rules.nix
    ./settings.nix
  ];

  home.packages = [ pkgs.playerctl ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };
}
