{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      setopt correct
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons --color=always $realpath'
    '';
    shellAliases = {
      b = "bat";
      c = "clear";
      h = "history";
      ff = "fastfetch";
      ll = "eza -lh";
      la = "eza -a";
      lah = "eza -lah";
      lt = "eza -aT";
      nck = "nix flake check ~/nixdots";
      ncl = "nh clean all";
      nrb = "nh os build";
      nrt = "nh os test";
      nrs = "nh os switch";
      nrbt = "nh os boot";
      nup = "nix flake update --flake ~/nixdots";
      nupg = "nix flake update --flake ~/nixdots && nix flake check ~/nixdots && nh os switch";
    };
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "autopair";
        src = pkgs.zsh-autopair;
        file = "share/zsh/zsh-autopair/autopair.zsh";
      }
      {
        name = "sudo";
        src = pkgs.oh-my-zsh;
        file = "share/oh-my-zsh/plugins/sudo/sudo.plugin.zsh";
      }
      {
        name = "extract";
        src = pkgs.oh-my-zsh;
        file = "share/oh-my-zsh/plugins/extract/extract.plugin.zsh";
      }
    ];
  };
}
