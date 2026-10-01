{ inputs, pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      bluetui
      wiremix
      speedtest-cli
    ])
    ++ [ inputs.wlctl.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}
