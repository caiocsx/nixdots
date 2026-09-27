{ ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      window_padding_width = 4;
      confirm_os_window_close = 0;
      scrollback_lines = 10000;
      enable_audio_bell = false;
      cursor_trail = 1;
    };
  };
}
