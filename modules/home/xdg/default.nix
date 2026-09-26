{ ... }:
{
  imports = [
    ./desktop-entries.nix
    ./mime-apps.nix
    ./user-dirs.nix
  ];

  xdg.enable = true;
}
