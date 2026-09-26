{ ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Browser
      "application/pdf" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
      "x-scheme-handler/chrome" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";

      # Chat
      "x-scheme-handler/discord" = [ "vesktop.desktop" ];

      # Editor
      "application/json" = "codium.desktop";
      "text/css" = "codium.desktop";
      "text/html" = "codium.desktop";
      "text/markdown" = "codium.desktop";
      "text/plain" = "codium.desktop";

      # Images
      "image/bmp" = "imv-dir.desktop";
      "image/gif" = "imv-dir.desktop";
      "image/heif" = "imv-dir.desktop";
      "image/jpeg" = "imv-dir.desktop";
      "image/png" = "imv-dir.desktop";
      "image/svg+xml" = "imv-dir.desktop";
      "image/tiff" = "imv-dir.desktop";
      "image/webp" = "imv-dir.desktop";

      # Media
      "audio/flac" = "mpv.desktop";
      "audio/mp4" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
      "audio/wav" = "mpv.desktop";
      "audio/x-m4a" = "mpv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/mpeg" = "mpv.desktop";
      "video/ogg" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/x-flv" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/x-ms-wmv" = "mpv.desktop";
      "video/x-msvideo" = "mpv.desktop";

      # Terminal
      "x-scheme-handler/terminal" = "kitty.desktop";
    };
  };
}
