{ config, ... }:
{
  programs.nh = {
    enable = true;
    osFlake = "${config.home.homeDirectory}/nixdots";
  };
}
