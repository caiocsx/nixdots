{ ... }:
{
  imports = [
    ./desktop
    ./packages
    ./theme
    ./xdg
    ./programs/btop.nix
    ./programs/discord.nix
    ./programs/fastfetch.nix
    ./programs/git.nix
    ./programs/imv.nix
    ./programs/kitty.nix
    ./programs/mpv.nix
    ./programs/shell.nix
    ./programs/spotify.nix
    ./programs/vscodium.nix
    ./programs/zen-browser.nix
    ./programs/zsh.nix
  ];

  home = {
    username = "caiocsx";
    homeDirectory = "/home/caiocsx";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
