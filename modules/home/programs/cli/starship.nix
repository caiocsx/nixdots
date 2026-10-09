{ ... }:
{
  programs.starship = {
    enable = true;
    presets = [ "nerd-font-symbols" ];
    settings = {
      battery.disabled = true;
      nix_shell.disabled = true;
    };
  };
}
