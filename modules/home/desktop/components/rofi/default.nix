{ ... }:
{
  imports = [
    ./scripts
  ];

  programs.rofi = {
    enable = true;
    settings = {
      drun-exclude-categories = "Game";
    };
  };
}
