{ inputs, theme, ... }:
let
  muted = "{#${theme.colors.muted}}";
  foreground = "{#${theme.colors.foreground}}";
  blue = "{#${theme.colors.blue}}";
  green = "{#${theme.colors.green}}";
in
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "${inputs.self}/assets/fastfetch/*.png";
        type = "kitty-direct";
        width = 30;
        height = 20;
        padding = {
          right = 3;
          left = 5;
        };
      };
      display = {
        separator = "";
        percent = {
          type = 1;
          width = 3;
        };
      };
      modules = [
        "break"
        {
          type = "custom";
          format = "${foreground}{{";
        }
        {
          type = "title";
          key = "  ${muted}system.${blue}host       ${foreground}= ";
          format = ''${green}"{user-name}@{host-name}"${foreground};'';
        }
        {
          type = "os";
          key = "  ${muted}system.${blue}os         ${foreground}= ";
          format = "${green}\"{name} {version}\"${foreground};";
        }
        {
          type = "kernel";
          key = "  ${muted}system.${blue}kernel     ${foreground}= ";
          format = "${green}\"{sysname} {release}\"${foreground};";
        }
        {
          type = "wm";
          key = "  ${muted}system.${blue}wm         ${foreground}= ";
          format = "${green}\"{pretty-name} {version}\"${foreground};";
        }
        {
          type = "packages";
          key = "  ${muted}system.${blue}packages   ${foreground}= ";
          format = "${foreground}[ ${green}\"{nix-system} nix-system\" \"{nix-user} nix-user\"${foreground} ];";
        }
        "break"
        {
          type = "cpu";
          key = "  ${muted}hardware.${blue}cpu      ${foreground}= ";
          format = "${green}\"{name} ({cores-physical}/{cores-logical})\"${foreground};";
        }
        {
          type = "gpu";
          key = "  ${muted}hardware.${blue}gpu      ${foreground}= ";
          format = "${green}\"{vendor} {name}\"${foreground};";
        }
        {
          type = "memory";
          key = "  ${muted}hardware.${blue}ram      ${foreground}= ";
          format = "${green}\"{used}/{total}\"${foreground};   ${muted}# {percentage}";
        }
        {
          type = "disk";
          folders = "/";
          key = "  ${muted}hardware.${blue}disk0    ${foreground}= ";
          format = "${green}\"{size-used}/{size-total}\"${foreground};  ${muted}# {size-percentage}";
        }
        "break"
        {
          type = "terminal";
          key = "  ${muted}terminal.${blue}term     ${foreground}= ";
          format = "${green}\"{pretty-name}\"${foreground};";
        }
        {
          type = "shell";
          key = "  ${muted}terminal.${blue}shell    ${foreground}= ";
          format = "${green}\"{pretty-name} {version}\"${foreground};";
        }
        "break"
        {
          type = "uptime";
          key = "  ${muted}info.${blue}uptime       ${foreground}= ";
          format = "${green}\"{days} days, {hours} hours, {minutes} mins\"${foreground};";
        }
        {
          type = "datetime";
          key = "  ${muted}info.${blue}dateTime     ${foreground}= ";
          format = "${green}\"{year}-{month-pretty}-{day-in-month} {hour-pretty}:{minute-pretty}\"${foreground};";
        }
        {
          type = "disk";
          folders = "/";
          key = "  ${muted}info.${blue}osAge        ${foreground}= ";
          format = "${green}\"{days} days\"${foreground};";
        }
        {
          type = "custom";
          format = "${foreground}}";
        }
        "break"
      ];
    };
  };
}
