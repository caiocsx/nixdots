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
    nixfmt
    codex
  ];
}
