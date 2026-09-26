{ ... }:
{
  boot = {
    loader = {
      timeout = 20;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    tmp.useTmpfs = true;
  };
}
