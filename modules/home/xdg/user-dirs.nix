{ config, ... }:
{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
    desktop = null;
    templates = null;
    publicShare = null;
    projects = "${config.home.homeDirectory}/Projects";
    extraConfig = {
      SCREENSHOTS = "${config.home.homeDirectory}/Pictures/Screenshots";
      WALLPAPERS = "${config.home.homeDirectory}/Pictures/Wallpapers";
    };
  };
}
