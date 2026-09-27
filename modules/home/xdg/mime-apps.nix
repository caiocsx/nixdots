{ ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/terminal" = "kitty.desktop";

      "inode/directory" = "thunar.desktop";
      "application/x-directory" = "thunar.desktop";

      "application/vnd.rar" = "org.gnome.FileRoller.desktop";
      "application/x-rar" = "org.gnome.FileRoller.desktop";
      "application/x-rar-compressed" = "org.gnome.FileRoller.desktop";
      "application/zip" = "org.gnome.FileRoller.desktop";
      "application/x-zip-compressed" = "org.gnome.FileRoller.desktop";
      "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
      "application/x-tar" = "org.gnome.FileRoller.desktop";
      "application/x-gzip" = "org.gnome.FileRoller.desktop";
      "application/x-bzip2" = "org.gnome.FileRoller.desktop";

      "application/pdf" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
      "x-scheme-handler/chrome" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";

      "application/json" = "codium.desktop";
      "text/css" = "codium.desktop";
      "text/html" = "codium.desktop";
      "text/markdown" = "codium.desktop";
      "text/plain" = "codium.desktop";

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
