{ ... }:
{
  imports = [
    ./rofi
    ./packages.nix
    ./controls.nix
    ./services.nix
    ./hyprlock.nix
    ./swayidle.nix
    ./swaync.nix
    ./waybar.nix
  ];
}
