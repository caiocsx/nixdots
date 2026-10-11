{ pkgs, ... }:
{
  home.packages = with pkgs; [
    proton-vpn
    proton-pass
    protonmail-desktop
    gimp
    obsidian
    onlyoffice-desktopeditors
    stremio-linux-shell
  ];
}
