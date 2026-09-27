{ pkgs, ... }:
{
  home.packages = with pkgs; [
    proton-vpn
    proton-pass
    protonmail-desktop
    obsidian
    onlyoffice-desktopeditors
    qalculate-gtk
    stremio-linux-shell
  ];
}
