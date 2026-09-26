{ pkgs, ... }:
{
  home.packages = with pkgs; [
    curl
    jq
    p7zip
    playerctl
    ripgrep
    unzip
    wget
    zip
  ];
}
