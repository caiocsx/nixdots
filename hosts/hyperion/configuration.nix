{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/hardware/amd.nix

    ../../modules/nixos/core
    ../../modules/nixos/desktop
    ../../modules/nixos/services

    ../../modules/nixos/programs/thunar.nix
    ../../modules/nixos/programs/zsh.nix
  ];

  home-manager.users.caiocsx.imports = [ ./home.nix ];
  networking.hostName = "hyperion";
  system.stateVersion = "26.05";
}
