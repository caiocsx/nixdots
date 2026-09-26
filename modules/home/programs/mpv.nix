{ ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      save-position-on-quit = true;
    };
  };
}
