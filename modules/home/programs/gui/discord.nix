{ inputs, ... }:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;
    discord.enable = false;
    vesktop.enable = true;
    config = {
      useQuickCss = true;
      frameless = true;
      plugins = {
        noTrack.enable = true;
        messageLogger = {
          enable = true;
          ignoreSelf = true;
        };
        fakeNitro.enable = true;
        callTimer.enable = true;
        volumeBooster.enable = true;
        fixImagesQuality.enable = true;
        readAllNotificationsButton.enable = true;
        silentMessageToggle.enable = true;
        platformIndicators.enable = true;
        relationshipNotifier.enable = true;
        memberCount.enable = true;
        spotifyControls.enable = true;
      };
    };
  };
}
