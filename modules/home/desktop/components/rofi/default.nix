{ ... }:
{
  imports = [
    ./scripts
  ];

  programs.rofi = {
    enable = true;
    extraConfig = {
      drun-exclude-categories = "Game";
    };
  };
}
