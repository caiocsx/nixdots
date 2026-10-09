{ ... }:
{
  programs.eza = {
    enable = true;
    git = true;
    colors = "always";
    icons = "always";
    extraOptions = [
      "--group-directories-first"
      "--no-quotes"
      "--header"
      "--time-style=long-iso"
      "--classify"
      "--hyperlink=auto"
    ];
  };
}
