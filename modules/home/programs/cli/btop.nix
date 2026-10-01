{ ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      io_mode = true;
    };
  };
}
