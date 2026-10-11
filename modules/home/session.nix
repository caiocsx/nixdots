{ config, ... }:
{
  home = {
    sessionPath = [
      "${config.home.homeDirectory}/.cargo/bin"
    ];

    sessionVariables = {
      TERMINAL = "kitty";
      FILE_MANAGER = "thunar";
      BROWSER = "zen-beta";
      EDITOR = "codium";
      SYSTEM_MONITOR = "btop";
    };
  };
}
