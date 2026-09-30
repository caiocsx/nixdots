{ pkgs, ... }:
{
  home.packages = with pkgs; [
    proton-vpn
    proton-pass
    protonmail-desktop
    obsidian
    onlyoffice-desktopeditors
    stremio-linux-shell
  ];
}
