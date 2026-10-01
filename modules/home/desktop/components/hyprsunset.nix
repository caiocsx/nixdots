{ ... }:
{
  services.hyprsunset = {
    enable = true;
    settings.profile = [
      {
        time = "06:00";
        temperature = 6000;
      }
      {
        time = "16:00";
        temperature = 5500;
      }
      {
        time = "18:00";
        temperature = 5000;
      }
      {
        time = "20:00";
        temperature = 4500;
      }
      {
        time = "22:00";
        temperature = 4000;
      }
      {
        time = "00:00";
        temperature = 3500;
      }
    ];
  };
}
