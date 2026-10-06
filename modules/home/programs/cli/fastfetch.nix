{ inputs, ... }:
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
          format = "{##727272}{{";
        }
        {
          type = "title";
          key = "  {##575757}system.{##7E97AB}host       {##727272}= ";
          format = ''{##88afa2}"{user-name}@{host-name}"{##727272};'';
        }
        {
          type = "os";
          key = "  {##575757}system.{##7E97AB}os         {##727272}= ";
          format = "{##88afa2}\"{name} {version}\"{##727272};";
        }
        {
          type = "kernel";
          key = "  {##575757}system.{##7E97AB}kernel     {##727272}= ";
          format = "{##88afa2}\"{sysname} {release}\"{##727272};";
        }
        {
          type = "wm";
          key = "  {##575757}system.{##7E97AB}wm         {##727272}= ";
          format = "{##88afa2}\"{pretty-name} {version}\"{##727272};";
        }
        {
          type = "packages";
          key = "  {##575757}system.{##7E97AB}packages   {##727272}= ";
          format = "{##727272}[ {##88afa2}\"{nix-system} nix-system\" \"{nix-user} nix-user\"{##727272} ];";
        }
        "break"
        {
          type = "cpu";
          key = "  {##575757}hardware.{##7E97AB}cpu      {##727272}= ";
          format = "{##88afa2}\"{name} ({cores-physical}/{cores-logical})\"{##727272};";
        }
        {
          type = "gpu";
          key = "  {##575757}hardware.{##7E97AB}gpu      {##727272}= ";
          format = "{##88afa2}\"{vendor} {name}\"{##727272};";
        }
        {
          type = "memory";
          key = "  {##575757}hardware.{##7E97AB}ram      {##727272}= ";
          format = "{##88afa2}\"{used}/{total}\"{##727272};   {##575757}# {percentage}";
        }
        {
          type = "disk";
          folders = "/";
          key = "  {##575757}hardware.{##7E97AB}disk0    {##727272}= ";
          format = "{##88afa2}\"{size-used}/{size-total}\"{##727272};  {##575757}# {size-percentage}";
        }
        "break"
        {
          type = "terminal";
          key = "  {##575757}terminal.{##7E97AB}term     {##727272}= ";
          format = "{##88afa2}\"{pretty-name}\"{##727272};";
        }
        {
          type = "shell";
          key = "  {##575757}terminal.{##7E97AB}shell    {##727272}= ";
          format = "{##88afa2}\"{pretty-name} {version}\"{##727272};";
        }
        "break"
        {
          type = "uptime";
          key = "  {##575757}info.{##7E97AB}uptime       {##727272}= ";
          format = "{##88afa2}\"{days} days, {hours} hours, {minutes} mins\"{##727272};";
        }
        {
          type = "datetime";
          key = "  {##575757}info.{##7E97AB}dateTime     {##727272}= ";
          format = "{##88afa2}\"{year}-{month-pretty}-{day-in-month} {hour-pretty}:{minute-pretty}\"{##727272};";
        }
        {
          type = "disk";
          folders = "/";
          key = "  {##575757}info.{##7E97AB}osAge        {##727272}= ";
          format = "{##88afa2}\"{days} days\"{##727272};";
        }
        {
          type = "custom";
          format = "{##727272}}";
        }
        "break"
      ];
    };
  };
}
