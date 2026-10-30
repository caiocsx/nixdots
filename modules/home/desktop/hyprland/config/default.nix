{ inputs, pkgs, ... }:
let
  hyprexpo = pkgs.callPackage inputs.hyprexpo { };
in
{
  imports = [
    ./animations.nix
    ./binds.nix
    ./rules.nix
    ./settings.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    plugins = [ hyprexpo ];
  };
}
