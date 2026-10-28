{ inputs, pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      bluetui
      hyprpicker
      speedtest-cli
      wiremix
      wl-clipboard
    ])
    ++ [ inputs.wlctl.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}
