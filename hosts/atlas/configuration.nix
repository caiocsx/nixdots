{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/hardware/nvidia.nix

    ../../modules/nixos/core
    ../../modules/nixos/desktop
    ../../modules/nixos/services

    ../../modules/nixos/programs/steam.nix
    ../../modules/nixos/programs/thunar.nix
    ../../modules/nixos/programs/zsh.nix
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  home-manager.users.caiocsx.imports = [ ./home.nix ];
  networking.hostName = "atlas";
  system.stateVersion = "26.05";
}
