{ inputs, theme, ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "file";
        source = "${inputs.self}/assets/fastfetch/ghost.txt";
        color = {
          "1" = "white";
        };
        padding = {
          top = 1;
          right = 5;
          left = 3;
        };
      };
      display = {
        separator = "  ";
        color = "white";
        percent = {
          type = 1;
          width = 3;
        };
      };
      modules = [
        "break"
        {
          type = "custom";
          key = "╭─────────────────────────────────────────╮";
        }
        {
          type = "custom";
          key = "│                                         │";
        }
        {
          type = "os";
          key = "│  OS           ";
          format = "{name>22}  │";
        }
        {
          type = "command";
          key = "│  Kernel       ";
          text = "uname -r | cut -d '-' -f1";
          format = "{>22}  │";
        }
        {
          type = "wm";
          key = "│  WM           ";
          format = "{pretty-name>22}  │";
        }
        {
          type = "terminal";
          key = "│  Terminal       ";
          format = "{pretty-name>20}  │";
        }
        {
          type = "shell";
          key = "│  Shell        ";
          format = "{pretty-name>22}  │";
        }
        {
          type = "packages";
          key = "│  Packages     ";
          format = "{all>22}  │";
        }
        {
          type = "memory";
          key = "│  RAM          ";
          format = "{used>9} / {total>10}  │";
        }
        {
          type = "disk";
          folders = "/";
          key = "│  Disk         ";
          format = "{size-used>9} / {size-total>10}  │";
        }
        {
          type = "command";
          key = "│  Date/Time    ";
          text = "date '+%Y-%m-%d %H:%M'";
          format = "{>22}  │";
        }
        {
          type = "disk";
          folders = "/";
          key = "│  OS Age       ";
          format = "{days>17} days  │";
        }
        {
          type = "custom";
          key = "│                                         │";
        }
        {
          type = "custom";
          key = "│      Keep learning, keep building.      │";
        }
        {
          type = "custom";
          key = "╰─────────────────────────────────────────╯";
        }
        "break"
      ];
    };
  };
}
