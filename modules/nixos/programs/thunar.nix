{ pkgs, ... }:
let
  thunarArchivePlugin = pkgs.thunar-archive-plugin.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      install -Dm755 ${pkgs.xarchiver}/libexec/thunar-archive-plugin/xarchiver.tap \
        $out/libexec/thunar-archive-plugin/xarchiver.tap
    '';
  });
in
{
  programs = {
    thunar = {
      enable = true;
      plugins = [
        thunarArchivePlugin
        pkgs.thunar-volman
      ];
    };
    xfconf.enable = true;
  };
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xarchiver
    ffmpegthumbnailer
  ];
}
