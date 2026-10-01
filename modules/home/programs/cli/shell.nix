{ config, ... }:
{
  programs = {
    nh = {
      enable = true;
      osFlake = "${config.home.homeDirectory}/nixdots";
    };
    direnv.enable = true;
    starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
      settings.battery.disabled = true;
    };
    fzf = {
      enable = true;
      defaultCommand = "fd --type f";
      defaultOptions = [
        "--height=40%"
        "--layout=reverse"
        "--border"
        "--info=inline"
      ];
      fileWidget = {
        options = [
          "--walker-skip=.git,node_modules,target,dist,.direnv,result"
          "--preview 'bat -n --color=always {} || cat {}'"
          "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
        ];
      };
      historyWidget = {
        zsh.command = "";
        options = [
          "--style=full"
        ];
      };
    };
    eza = {
      enable = true;
      git = true;
      colors = "always";
      icons = "always";
      extraOptions = [
        "--group-directories-first"
        "--no-quotes"
        "--header"
        "--time-style=long-iso"
        "--classify"
        "--hyperlink=auto"
      ];
    };
    bat.enable = true;
    zoxide.enable = true;
  };
}
