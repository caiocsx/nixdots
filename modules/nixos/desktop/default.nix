{ ... }:
{
  imports = [ ./hyprland.nix ];
  security.pam.services = {
    hyprlock = { };
  };
}
