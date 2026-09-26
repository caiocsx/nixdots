{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bluetui
    libnotify
  ];
}
