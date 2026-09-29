{ ... }:
{
  imports = [
    ./rofi
    ./packages.nix
    ./services.nix
    ./hyprlock.nix
    ./swayidle.nix
    ./swaync.nix
    ./waybar.nix
  ];
}
