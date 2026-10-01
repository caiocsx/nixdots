{ inputs, pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      bluetui
      speedtest-cli
    ])
    ++ [ inputs.wlctl.packages.${pkgs.system}.default ];
}
