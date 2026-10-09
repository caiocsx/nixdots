{ ... }:
{
  programs.starship = {
    enable = true;
    presets = [ "nerd-font-symbols" ];
    settings = {
      battery.disabled = true;
    };
  };
}
