{ inputs, ... }:
let
  mkExtension = addonName: addonId: {
    name = addonId;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${addonName}/latest.xpi";
      installation_mode = "normal_installed";
      private_browsing = true;
    };
  };
  extensions = [
    (mkExtension "ublock-origin" "uBlock0@raymondhill.net")
    (mkExtension "consent-o-matic" "gdpr@cavi.au.dk")
    (mkExtension "proton-pass" "78272b6fa58f4a1abaac99321d503a20@proton.me")
    (mkExtension "proton-vpn-firefox-extension" "vpn@proton.ch")
    (mkExtension "darkreader" "addon@darkreader.org")
    (mkExtension "absolute-enable-right-click" "{9350bc42-47fb-4598-ae0f-825e3dd9ceba}")
    (mkExtension "youtube-no-translation" "{9a3104a2-02c2-464c-b069-82344e5ed4ec}")
  ];
in
{
  imports = [ inputs.zen-browser.homeModules.default ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      DisablePocket = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      HardwareAcceleration = true;
      SearchSuggestEnabled = false;
      HttpsOnlyMode = "enabled";
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Category = "strict";
      };
      DNSOverHTTPS = {
        Enabled = true;
        Locked = true;
        ProviderURL = "https://dns.quad9.net/dns-query";
      };
      ExtensionSettings = builtins.listToAttrs extensions;
      "3rdparty".Extensions = {
        "uBlock0@raymondhill.net" = {
          toOverwrite = {
            filterLists = [
              "user-filters"
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-unbreak"
              "ublock-quick-fixes"
              "easylist"
              "easyprivacy"
              "urlhaus-1"
              "plowe-0"
              "fanboy-cookiemonster"
              "easylist-annoyances"
              "ublock-annoyances"
              "adguard-cookies"
              "adguard-spyware-url"
            ];
          };
        };
      };
      SearchEngines = {
        Default = "DuckDuckGo";
        PreventInstalls = true;
        Remove = [
          "Bing"
          "Google"
          "Perplexity"
          "Wikipedia (en)"
        ];
        Add = [
          {
            Name = "YouTube";
            URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}";
            Method = "GET";
            IconURL = "https://www.google.com/s2/favicons?domain=youtube.com&sz=128";
            Alias = "yt";
          }
          {
            Name = "Wikipedia";
            URLTemplate = "https://en.wikipedia.org/wiki/Special:Search?search={searchTerms}";
            Method = "GET";
            IconURL = "https://www.google.com/s2/favicons?domain=wikipedia.org&sz=128";
            Alias = "wk";
          }
          {
            Name = "Nix Packages";
            URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
            Method = "GET";
            IconURL = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/logo/nix-snowflake-colours.svg";
            Alias = "nxp";
          }
          {
            Name = "Nix Options";
            URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
            Method = "GET";
            IconURL = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/logo/nix-snowflake-colours.svg";
            Alias = "nxo";
          }
        ];
      };
    };
    profiles.default = {
      isDefault = true;
      spacesForce = true;
      pinsForce = true;
      settings = {
        "zen.welcome-screen.seen" = true;
        "zen.workspaces.continue-where-left-off" = true;
        "zen.view.compact.enable-at-startup" = true;
        "zen.view.compact.hide-tabbar" = true;
        "zen.urlbar.behavior" = "float";
      };
      mods = [
        "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
        "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
        "7190e4e9-bead-4b40-8f57-95d852ddc941" # Tab title fixes
        "803c7895-b39b-458e-84f8-a521f4d7a064" # Hide Inactive Workspaces
        "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
      ];
      pins = {
        "YouTube" = {
          id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
          url = "https://youtube.com";
          isEssential = true;
          position = 101;
        };
        "Proton Mail" = {
          id = "f02c8ad1-83e1-4b8d-9a72-6c3410e5b827";
          url = "https://mail.proton.me";
          isEssential = true;
          position = 102;
        };
        "Whatsapp" = {
          id = "e4067f49-45aa-4200-9468-97c7296154f4";
          url = "https://web.whatsapp.com/";
          isEssential = true;
          position = 103;
        };
        "GitHub" = {
          id = "4f765c89-2fca-4561-8a34-44ba1ddac904";
          url = "https://github.com";
          isEssential = true;
          position = 104;
        };
        "ChatGPT" = {
          id = "9cbe689c-65f2-4400-a0ad-5efd052dad4b";
          url = "https://chatgpt.com";
          isEssential = true;
          position = 105;
        };
        "Reddit" = {
          id = "48e8a119-5a14-4826-9545-91c8e8dd3bf6";
          url = "https://reddit.com";
          isEssential = true;
          position = 106;
        };
      };
      spaces = {
        "Personal" = {
          id = "c6de089c-410d-4206-961d-ab11f988d40a";
          position = 1000;
          icon = "🏠";
        };
        "Dev" = {
          id = "f9db866c-da35-43a8-8863-d2ddb419b5ae";
          position = 2000;
          icon = "💻";
        };
        "Study" = {
          id = "78aabdad-8aae-4fe0-8ff0-2a0c6c4ccc24";
          position = 3000;
          icon = "📚";
        };
        "Work" = {
          id = "cdd10fab-4fc5-494b-9041-325e5759195b";
          position = 4000;
          icon = "💼";
        };
        "Shopping" = {
          id = "01a3de97-93e1-44be-84b3-74c51e5b11e9";
          position = 5000;
          icon = "🛒";
        };
      };
    };
  };
}
