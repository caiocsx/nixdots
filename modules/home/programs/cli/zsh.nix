{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      export YSU_IGNORED_ALIASES=("ls" "eza")
      setopt correct
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons --color=always $realpath'
    '';
    shellAliases = {
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
      nrboot = "nh os boot";
      nup = "nix flake update --flake ~/nixdots";
      nupg = "nix flake update --flake ~/nixdots && nix flake check ~/nixdots && nh os switch";
    };
    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
        file = "fzf-tab.plugin.zsh";
      }
      {
        name = "you-should-use";
        src = "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use";
        file = "you-should-use.plugin.zsh";
      }
      {
        name = "autopair";
        src = "${pkgs.zsh-autopair}/share/zsh/zsh-autopair";
        file = "autopair.zsh";
      }
    ];
  };
}
