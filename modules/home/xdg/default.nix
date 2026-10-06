{ ... }:
{
  imports = [
    ./apps
    ./desktop-entries.nix
    ./mime-apps.nix
    ./user-dirs.nix
  ];

  xdg.enable = true;
}
