{ pkgs, ... }:
{
  imports = [
    ../../common
    ./animations.nix
    ./binds.nix
    ./rules.nix
    ./settings.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };
}
