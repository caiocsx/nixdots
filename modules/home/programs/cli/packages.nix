{ pkgs, ... }:
{
  home.packages = with pkgs; [
    curl
    wget
    p7zip
    unzip
    zip
    jq
    ripgrep
    fd
    nixfmt
    codex
    gcc
    gnumake
  ];
}
