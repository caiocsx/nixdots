{ config, ... }:
{
  programs.swappy = {
    enable = true;
    settings.Default = {
      save_dir = config.xdg.userDirs.extraConfig.SCREENSHOTS;
      save_filename_format = "%Y-%m-%d_%H-%M-%S.png";
      show_panel = true;
    };
  };
}
