{ ... }:
{
  services.wlsunset = {
    enable = true;
    sunrise = "06:00";
    sunset = "18:00";
    temperature = {
      day = 5500;
      night = 4500;
    };
  };
}
