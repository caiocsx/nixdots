{ ... }:
{
  time.timeZone = "America/Recife";
  services.timesyncd.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  console.useXkbConfig = true;
  documentation.nixos.enable = false;
}
