{ ... }:
{
  programs.yazi = {
    enable = true;
    settings = {
      mgr = {
        scrolloff = 5;
        sort_dir_first = true;
        show_hidden = true;
        show_symlink = true;
        linemode = "size";
        ratio = [
          1
          3
          4
        ];
      };
      preview = {
        tab_size = 4;
        image_filter = "triangle";
        max_width = 1920;
        max_height = 1080;
        image_quality = 90;
        wrap = "yes";
      };
    };
  };
}
