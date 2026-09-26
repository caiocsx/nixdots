{ ... }:
{
  networking.networkmanager.enable = true;
  users.users.caiocsx.extraGroups = [
    "networkmanager"
  ];
}
