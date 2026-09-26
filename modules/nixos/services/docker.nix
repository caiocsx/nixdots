{ ... }:
{
  virtualisation.docker.enable = true;
  users.users.caiocsx.extraGroups = [
    "docker"
  ];
}
