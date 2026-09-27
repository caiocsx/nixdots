{ pkgs, ... }:
{
  services.displayManager = {
    ly = {
      enable = true;
      x11Support = false;
      settings = {
        animation = "matrix";
        hide_key_hints = true;
        save = true;
        bigclock = "en";
        default_input = "password";
        clear_password = true;
      };
    };
  };
}
