{ pkgs, ... }:
{
  imports = [
    ../../modules/home/desktop/shells/modular
  ];

  home.packages = with pkgs; [
    brightnessctl
  ];
}
