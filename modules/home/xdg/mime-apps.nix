{ ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "thunar.desktop";
      "application/x-directory" = "thunar.desktop";

      "application/vnd.rar" = "xarchiver.desktop";
      "application/x-rar" = "xarchiver.desktop";
      "application/x-rar-compressed" = "xarchiver.desktop";
      "application/zip" = "xarchiver.desktop";
      "application/x-zip-compressed" = "xarchiver.desktop";
      "application/x-7z-compressed" = "xarchiver.desktop";
      "application/x-tar" = "xarchiver.desktop";
      "application/x-gzip" = "xarchiver.desktop";
      "application/x-bzip2" = "xarchiver.desktop";

      "application/pdf" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
      "x-scheme-handler/chrome" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";

      "application/json" = "codium.desktop";
      "text/css" = "codium.desktop";
      "text/html" = "codium.desktop";
      "text/markdown" = "codium.desktop";

      "text/csv" = "org.xfce.mousepad.desktop";
      "text/plain" = "org.xfce.mousepad.desktop";
      "text/tab-separated-values" = "org.xfce.mousepad.desktop";

      "image/bmp" = "imv-dir.desktop";
      "image/gif" = "imv-dir.desktop";
      "image/heif" = "imv-dir.desktop";
      "image/jpeg" = "imv-dir.desktop";
      "image/png" = "imv-dir.desktop";
      "image/svg+xml" = "imv-dir.desktop";
      "image/tiff" = "imv-dir.desktop";
      "image/webp" = "imv-dir.desktop";

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

      "x-scheme-handler/discord" = [ "vesktop.desktop" ];
    };
  };
}
