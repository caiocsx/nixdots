{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "caiocsx";
      user.email = "caiocesarsts@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autoStash = true;
      fetch.prune = true;
      push.autoSetupRemote = true;
    };
  };
}
