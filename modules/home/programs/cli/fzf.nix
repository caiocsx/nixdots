{ ... }:
{
  programs.fzf = {
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
}
