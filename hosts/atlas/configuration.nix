{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/hardware/nvidia.nix

    ../../modules/nixos/core
    ../../modules/nixos/desktop
    ../../modules/nixos/services
    ../../modules/nixos/programs
  ];

  home-manager.users.caiocsx.imports = [ ./home.nix ];
  networking.hostName = "atlas";
  system.stateVersion = "26.05";
}
